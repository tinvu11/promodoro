import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:promodoro/data/repositories/remote_data_repo.dart';
import 'package:promodoro/services/theme_storage_service.dart';
import 'package:promodoro/ui/screens/noises/bloc/noises_event.dart';
import 'package:promodoro/ui/screens/noises/bloc/noises_state.dart';

class NoisesBloc extends Bloc<NoisesEvent, NoisesState> {
  final RemoteDataRepo _remoteDataRepo;
  final ThemeStorageService _themeStorageService;
  final AudioPlayer _previewPlayer = AudioPlayer();

  static const int _maxRetries = 2;
  static const Duration _retryDelay = Duration(seconds: 2);

  NoisesBloc({
    required RemoteDataRepo remoteDataRepo,
    required ThemeStorageService themeStorageService,
  }) : _remoteDataRepo = remoteDataRepo,
       _themeStorageService = themeStorageService,
       super(const NoisesState()) {
    _previewPlayer.setLoopMode(LoopMode.one);

    on<LoadNoises>(_onLoadNoises);
    on<RefreshNoises>(_onRefreshNoises);
    on<SelectTheme>(_onSelectTheme);
    on<InitPreview>(_onInitPreview);
    on<TogglePreviewAudio>(_onTogglePreviewAudio);
    on<StopPreview>(_onStopPreview);
  }

  Future<void> _onLoadNoises(
    LoadNoises event,
    Emitter<NoisesState> emit,
  ) async {
    emit(state.copyWith(status: NoiseStatus.loading));
    // Load danh sách theme đã tải về local
    try {
      final downloadedIds = await _themeStorageService.getDownloadedThemeIds();
      // Theme mặc định luôn coi như đã tải (dùng asset)
      downloadedIds.add(ThemeStorageService.defaultThemeId);
      emit(state.copyWith(downloadedThemeIds: downloadedIds));
    } catch (e) {
      log('[NoisesBloc] Failed to load downloaded theme IDs', error: e);
    }
    await _fetchWithRetry(emit);
  }

  /// Pull-to-refresh: giữ data cũ trong khi đang tải mới
  Future<void> _onRefreshNoises(
    RefreshNoises event,
    Emitter<NoisesState> emit,
  ) async {
    await _fetchWithRetry(emit);
  }

  /// Xử lý khi người dùng chọn 1 theme từ grid.
  ///
  /// Flow:
  ///   - Nếu theme đã tải → chỉ emit downloaded (chuyển active) + preview
  ///   - Nếu chưa tải → emit downloading → tải → emit downloaded/failed + preview
  Future<void> _onSelectTheme(
    SelectTheme event,
    Emitter<NoisesState> emit,
  ) async {
    final themeId = event.theme.id;
    final themeName = event.theme.getLocalizedName(event.languageCode);
    log('[NoisesBloc] User selected theme: $themeName ($themeId)');

    // Nếu đang preview cùng theme → chỉ toggle audio
    if (state.previewThemeId == themeId) {
      await _toggleAudio(emit);
      return;
    }

    // Theme mặc định → không cần download, chỉ chuyển active + preview
    if (ThemeStorageService.isDefaultTheme(themeId)) {
      log('[NoisesBloc] Default theme selected. No download needed.');
      emit(
        state.copyWith(
          downloadStatus: ThemeDownloadStatus.idle,
          downloadingThemeId: themeId,
          themeName: themeName,
        ),
      );
      emit(
        state.copyWith(
          downloadStatus: ThemeDownloadStatus.downloaded,
          downloadingThemeId: themeId,
          themeName: themeName,
        ),
      );
      // Preview bằng asset mặc định
      await _startDefaultPreview(themeId, emit);
      return;
    }

    // Đã tải rồi → chỉ chuyển active + preview
    if (state.downloadedThemeIds.contains(themeId)) {
      log('[NoisesBloc] Theme already cached. Switching active.');
      // Reset về idle trước để listener nhận được transition idle → downloaded
      emit(
        state.copyWith(
          downloadStatus: ThemeDownloadStatus.idle,
          downloadingThemeId: themeId,
          themeName: themeName,
        ),
      );
      emit(
        state.copyWith(
          downloadStatus: ThemeDownloadStatus.downloaded,
          downloadingThemeId: themeId,
          themeName: themeName,
        ),
      );
      // Bắt đầu preview
      await _startPreview(themeId, emit);
      return;
    }

    // Chưa tải → bắt đầu download
    emit(
      state.copyWith(
        downloadStatus: ThemeDownloadStatus.downloading,
        downloadingThemeId: themeId,
      ),
    );

    try {
      final success = await _themeStorageService.downloadAndSaveTheme(
        event.theme,
      );

      if (success) {
        log('[NoisesBloc] Theme "$themeName" downloaded successfully.');
        final updatedIds = {...state.downloadedThemeIds, themeId};
        emit(
          state.copyWith(
            downloadStatus: ThemeDownloadStatus.downloaded,
            downloadingThemeId: themeId,
            downloadedThemeIds: updatedIds,
            themeName: themeName,
          ),
        );
        // Bắt đầu preview sau khi tải xong
        await _startPreview(themeId, emit);
      } else {
        log('[NoisesBloc] Theme download failed.');
        emit(
          state.copyWith(
            downloadStatus: ThemeDownloadStatus.failed,
            downloadingThemeId: null,
          ),
        );
      }
    } catch (e, stackTrace) {
      log('[NoisesBloc] SelectTheme error', error: e, stackTrace: stackTrace);
      emit(
        state.copyWith(
          downloadStatus: ThemeDownloadStatus.failed,
          downloadingThemeId: null,
        ),
      );
    }
  }

  /// Khởi tạo preview cho theme đang active khi mở trang.
  Future<void> _onInitPreview(
    InitPreview event,
    Emitter<NoisesState> emit,
  ) async {
    final themeId = event.themeId;
    if (themeId.isEmpty) return;
    try {
      // Theme mặc định → dùng asset, không cần file local
      if (ThemeStorageService.isDefaultTheme(themeId)) {
        // emit(
        //   state.copyWith(
        //     previewBgPath: ThemeStorageService.defaultBgAsset,
        //     previewThemeId: themeId,
        //   ),
        // );
        // return;
      }
      final bgPath = await _themeStorageService.bgPathOf(themeId);
      final hasLocal = await _themeStorageService.hasLocalBg(themeId);
      if (hasLocal) {
        emit(state.copyWith(previewBgPath: bgPath, previewThemeId: themeId));
      }
    } catch (e) {
      log('[NoisesBloc] Failed to init preview', error: e);
    }
  }

  /// Toggle play/pause audio preview.
  Future<void> _onTogglePreviewAudio(
    TogglePreviewAudio event,
    Emitter<NoisesState> emit,
  ) async {
    await _toggleAudio(emit);
  }

  /// Dừng hoàn toàn preview khi rời trang.
  Future<void> _onStopPreview(
    StopPreview event,
    Emitter<NoisesState> emit,
  ) async {
    log('[NoisesBloc] Stopping preview.');
    try {
      await _previewPlayer.stop();
    } catch (e) {
      log('[NoisesBloc] Failed to stop preview player', error: e);
    }
    emit(
      state.copyWith(
        isAudioPlaying: false,
        previewThemeId: null,
        previewBgPath: null,
      ),
    );
  }

  // ──────────────── Preview helpers ────────────────

  /// Preview cho theme mặc định (dùng asset thay vì file local).
  Future<void> _startDefaultPreview(
    String themeId,
    Emitter<NoisesState> emit,
  ) async {
    try {
      // previewBgPath = null → ThemeBackground sẽ fallback về asset mặc định
      emit(
        state.copyWith(
          previewBgPath: ThemeStorageService.defaultBgAsset,
          previewThemeId: themeId,
        ),
      );

      // Phát audio từ asset
      await _previewPlayer.stop();
      await _previewPlayer.setVolume(0.5);
      await _previewPlayer.setAsset(ThemeStorageService.defaultAudioAsset);
      await _previewPlayer.seek(Duration.zero);
      emit(state.copyWith(isAudioPlaying: true));

      _previewPlayer.play();
      log('[NoisesBloc] Default preview audio playing from asset.');
    } catch (e) {
      log('[NoisesBloc] Failed to start default preview', error: e);
    }
  }

  /// Bắt đầu preview cho theme: đổi bg + phát audio.
  Future<void> _startPreview(String themeId, Emitter<NoisesState> emit) async {
    try {
      final bgPath = await _themeStorageService.bgPathOf(themeId);
      final audioPath = await _themeStorageService.audioPathOf(themeId);

      emit(state.copyWith(previewBgPath: bgPath, previewThemeId: themeId));

      // Phát audio preview
      final hasAudio = await _themeStorageService.hasLocalAudio(themeId);
      if (hasAudio) {
        await _previewPlayer.stop();
        await _previewPlayer.setVolume(0.5);
        await _previewPlayer.setFilePath(audioPath);
        await _previewPlayer.seek(Duration.zero);
        emit(state.copyWith(isAudioPlaying: true));
        _previewPlayer.play();

        log('[NoisesBloc] Preview audio playing: $audioPath');
      }
    } catch (e) {
      log('[NoisesBloc] Failed to start preview', error: e);
    }
  }

  /// Toggle play/pause audio.
  Future<void> _toggleAudio(Emitter<NoisesState> emit) async {
    try {
      if (state.isAudioPlaying) {
        await _previewPlayer.pause();
        emit(state.copyWith(isAudioPlaying: false));
        log('[NoisesBloc] Preview audio paused.');
      } else {
        // Chưa phát → cần play (không chỉ resume)
        if (state.previewThemeId != null) {
          await _previewPlayer.stop();
          await _previewPlayer.setVolume(0.5);

          if (ThemeStorageService.isDefaultTheme(state.previewThemeId!)) {
            await _previewPlayer.setAsset(
              ThemeStorageService.defaultAudioAsset,
            );
            emit(state.copyWith(isAudioPlaying: true));
            await _previewPlayer.seek(Duration.zero);
            _previewPlayer.play();

            log('[NoisesBloc] Default preview audio playing.');
          } else {
            final audioPath = await _themeStorageService.audioPathOf(
              state.previewThemeId!,
            );
            final hasAudio = await _themeStorageService.hasLocalAudio(
              state.previewThemeId!,
            );
            if (hasAudio) {
              await _previewPlayer.setFilePath(audioPath);
              await _previewPlayer.seek(Duration.zero);
              emit(state.copyWith(isAudioPlaying: true));
              _previewPlayer.play();
              log('[NoisesBloc] Preview audio playing: $audioPath');
            }
          }
        }
      }
    } catch (e) {
      log('[NoisesBloc] Failed to toggle audio', error: e);
    }
  }

  @override
  Future<void> close() async {
    await _previewPlayer.dispose();
    return super.close();
  }

  /// Fetch dữ liệu với auto-retry khi gặp lỗi mạng
  Future<void> _fetchWithRetry(Emitter<NoisesState> emit) async {
    for (int attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        final dataNoises = await _remoteDataRepo.fetchLatestResources();
        if (dataNoises.isEmpty) {
          emit(
            state.copyWith(
              status: NoiseStatus.error,
              errorMessage: 'Không có dữ liệu. Kiểm tra kết nối mạng.',
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: NoiseStatus.success,
              themes: dataNoises,
              errorMessage: null,
            ),
          );
        }
        return; // Thành công → thoát
      } catch (e) {
        log(
          'Fetch attempt ${attempt + 1}/${_maxRetries + 1} failed',
          error: e,
          name: 'NoisesBloc',
        );

        if (attempt < _maxRetries) {
          await Future.delayed(_retryDelay);
        } else {
          // Hết retry → emit error
          emit(
            state.copyWith(
              status: NoiseStatus.error,
              errorMessage: 'Lỗi tải dữ liệu. Vuốt xuống để thử lại.',
            ),
          );
        }
      }
    }
  }
}
