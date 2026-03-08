import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promodoro/configs/di.dart';
import 'package:promodoro/core/Theme/app_fonts.dart';
import 'package:promodoro/data/models/theme_model.dart';
import 'package:promodoro/l10n/generated/app_localizations.dart';
import 'package:promodoro/services/theme_storage_service.dart';
import 'package:promodoro/ui/commons/widgets/common_appbar.dart';
import 'package:promodoro/ui/screens/noises/bloc/noises_bloc.dart';
import 'package:promodoro/ui/screens/noises/bloc/noises_event.dart';
import 'package:promodoro/ui/screens/noises/bloc/noises_state.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/Theme/app_colors.dart';
import '../../commons/widgets/theme_background.dart';

class NoisesPage extends StatefulWidget {
  const NoisesPage({super.key});

  @override
  State<NoisesPage> createState() => _NoisesPageState();
}

class _NoisesPageState extends State<NoisesPage> {
  late final NoisesBloc _noisesBloc;

  /// Đường dẫn bg tính sync để tránh nháy frame đầu tiên.
  String? _initialBgPath;

  /// true = có mạng, false = offline, null = đang kiểm tra.
  bool? _isOnline;

  @override
  void initState() {
    super.initState();
    _noisesBloc = context.read<NoisesBloc>();

    // Khởi tạo preview cho theme đang active
    final settingsState = context.read<SettingsBloc>().state;
    if (settingsState is SuccessSettingState) {
      final themeId = settingsState.settingsModel.selectedThemeId;
      if (themeId.isNotEmpty) {
        // Lấy path sync để hiện đúng bg ngay frame đầu tiên
        final service = DI.sl<ThemeStorageService>();
        _initialBgPath = service.bgPathOfSync(themeId);
        _noisesBloc.add(InitPreview(themeId: themeId));
      }
    }
    _checkConnectivityAndLoad();
  }

  Future<void> _checkConnectivityAndLoad() async {
    final result = await Connectivity().checkConnectivity();
    final online = result.any((r) => r != ConnectivityResult.none);
    if (mounted) setState(() => _isOnline = online);

    if (online && _noisesBloc.state.status == NoiseStatus.initial) {
      _noisesBloc.add(LoadNoises());
    }
  }

  @override
  void dispose() {
    // Dừng preview audio khi rời trang — dùng reference đã lưu
    _noisesBloc.add(StopPreview());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(title: l10n.backgroundSound),
      body: BlocListener<NoisesBloc, NoisesState>(
        listenWhen: (prev, curr) => prev.downloadStatus != curr.downloadStatus,
        listener: (context, state) {
          if (state.downloadStatus == ThemeDownloadStatus.downloaded) {
            // Lưu selectedThemeId vào SettingsBloc
            context.read<SettingsBloc>().add(
              SaveSettingsEvent(
                selectedThemeId: state.downloadingThemeId,
                themeName: state.themeName,
              ),
            );
          } else if (state.downloadStatus == ThemeDownloadStatus.failed) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text('Tải theme thất bại. Vui lòng thử lại.'),
            //     backgroundColor: Colors.redAccent,
            //     duration: Duration(seconds: 2),
            //   ),
            // );
          }
        },
        child: Stack(
          children: [
            BlocBuilder<NoisesBloc, NoisesState>(
              buildWhen: (prev, curr) =>
                  prev.previewBgPath != curr.previewBgPath,
              builder: (context, state) {
                // Dùng path sync làm fallback để không nháy frame đầu
                final bgPath = state.previewBgPath ?? _initialBgPath;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: RepaintBoundary(
                    key: ValueKey(bgPath ?? 'default'),
                    child: ThemeBackground(
                      localImagePath: bgPath,
                      sigmaX: 15,
                      sigmaY: 15,
                      darkAlpha: 0.55,
                    ),
                  ),
                );
              },
            ),

            BlocBuilder<NoisesBloc, NoisesState>(
              builder: (BuildContext context, state) {
                // Offline → hiển thị thông báo
                if (_isOnline == false && state.status != NoiseStatus.success) {
                  return SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wifi_off_rounded,
                              color: AppColors.textSecondary,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${l10n.noInternet}.\n${l10n.tryAgainConnect}.',
                              style: AppFonts.regular_white_16,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            TextButton.icon(
                              onPressed: _checkConnectivityAndLoad,
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              label: Text(
                                l10n.tryAgain,
                                style: AppFonts.regular_white_16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (state.status == NoiseStatus.loading) {
                  return SafeArea(child: _buildShimmerGrid());
                } else if (state.status == NoiseStatus.success) {
                  final data = state.themes;
                  final settingsState = context.watch<SettingsBloc>().state;
                  final selectedThemeId = settingsState is SuccessSettingState
                      ? settingsState.settingsModel.selectedThemeId
                      : '';
                  return SafeArea(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: data.length,
                      cacheExtent: 500,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.0,
                          ),
                      itemBuilder: (context, index) {
                        final theme = data[index];
                        final isDownloading =
                            state.downloadStatus ==
                                ThemeDownloadStatus.downloading &&
                            state.downloadingThemeId == theme.id;
                        final isActive = theme.id == selectedThemeId;
                        final isDownloaded = state.downloadedThemeIds.contains(
                          theme.id,
                        );
                        final isPreviewing = state.previewThemeId == theme.id;
                        return _NoiseGridItem(
                          theme: theme,
                          index: index,
                          isDownloading: isDownloading,
                          isActive: isActive,
                          isDownloaded: isDownloaded,
                          isPreviewing: isPreviewing,
                          isAudioPlaying: isPreviewing && state.isAudioPlaying,
                          onTap: () async {
                            // Nếu theme chưa tải → kiểm tra mạng trước
                            if (!isDownloaded && !isActive) {
                              final result = await Connectivity()
                                  .checkConnectivity();
                              final online = result.any(
                                (r) => r != ConnectivityResult.none,
                              );
                              if (!online && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    // 1. Phải để màu nền là trong suốt
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 30,
                                    ),

                                    // Tạo hình viên thuốc
                                    content: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        // Bo tròn viên thuốc
                                        child: BackdropFilter(
                                          // 2. Độ mờ của lớp kính (sigma càng cao càng mờ)
                                          filter: ImageFilter.blur(
                                            sigmaX: 18.0,
                                            sigmaY: 18.0,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              // 3. Màu nền trắng mờ (Opacity thấp)
                                              color: Colors.white.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              // 4. Viền trắng mỏng để làm nổi bật hiệu ứng kính
                                              border: Border.all(
                                                color: Colors.white.withOpacity(
                                                  0.2,
                                                ),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.wifi_off,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  l10n.noInternet,
                                                  style:
                                                      AppFonts.regular_white_14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                                return;
                              }
                            }
                            if (context.mounted) {
                              context.read<NoisesBloc>().add(
                                SelectTheme(
                                  theme: theme,
                                  languageCode: Localizations.localeOf(
                                    context,
                                  ).languageCode,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                } else if (state.status == NoiseStatus.error) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_off_rounded,
                            color: AppColors.textSecondary,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.errorMessage ?? 'Đã xảy ra lỗi',
                            style: AppFonts.regular_white_16,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Shimmer grid placeholder khi đang loading
  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 8,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.white.withValues(alpha: 0.1),
          highlightColor: Colors.white.withValues(alpha: 0.25),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}

class _NoiseGridItem extends StatelessWidget {
  final ThemeModel theme;
  final int index;
  final bool isDownloading;
  final bool isActive;
  final bool isDownloaded;
  final bool isPreviewing;
  final bool isAudioPlaying;
  final VoidCallback onTap;

  const _NoiseGridItem({
    required this.theme,
    required this.index,
    required this.isDownloading,
    required this.isActive,
    required this.isDownloaded,
    required this.isPreviewing,
    required this.isAudioPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDownloading ? null : onTap,
      child: Stack(
        children: [
          // Ảnh với fade-in animation
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: theme.imageUrl,
                fit: BoxFit.cover,
                memCacheWidth: 400,
                maxWidthDiskCache: 600,
                filterQuality: FilterQuality.medium,

                // Shimmer placeholder khi đang tải ảnh
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.white.withValues(alpha: 0.1),
                  highlightColor: Colors.white.withValues(alpha: 0.25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                // Fade-in khi ảnh load xong
                fadeInDuration: const Duration(milliseconds: 300),
                fadeOutDuration: const Duration(milliseconds: 150),

                // Widget hiển thị khi lỗi
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_rounded,
                        color: Colors.white54,
                        size: 32,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Lỗi tải ảnh',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Gradient overlay để text đọc rõ hơn
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),

          // Tên theme + status icon
          Positioned(
            left: 10,
            bottom: 10,
            right: 10,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    theme.getLocalizedName(
                      Localizations.localeOf(context).languageCode,
                    ),
                    style: AppFonts.regular_white_16,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Icon trạng thái
                if (isPreviewing)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isAudioPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_filled_rounded,
                      key: ValueKey(isAudioPlaying),
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                  )
                else if (isActive)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  )
                else if (!isDownloaded)
                  const Icon(
                    Icons.download_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
              ],
            ),
          ),

          // Loading overlay khi đang tải theme
          if (isDownloading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),

          // Viền highlight cho theme đang preview hoặc active
          if (isPreviewing || isActive)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isPreviewing
                        ? Colors.white.withOpacity(0.6)
                        : AppColors.glassBorder,
                    width: 1.75,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
