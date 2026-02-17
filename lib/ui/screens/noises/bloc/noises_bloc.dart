import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:promodoro/data/repositories/remote_data_repo.dart';
import 'package:promodoro/ui/screens/noises/bloc/noises_event.dart';
import 'package:promodoro/ui/screens/noises/bloc/noises_state.dart';

class NoisesBloc extends Bloc<NoisesEvent, NoisesState> {
  final RemoteDataRepo _remoteDataRepo;

  static const int _maxRetries = 2;
  static const Duration _retryDelay = Duration(seconds: 2);

  NoisesBloc({required RemoteDataRepo remoteDataRepo})
    : _remoteDataRepo = remoteDataRepo,
      super(const NoisesState()) {
    on<LoadNoises>(_onLoadNoises);
    on<RefreshNoises>(_onRefreshNoises);
  }

  Future<void> _onLoadNoises(
    LoadNoises event,
    Emitter<NoisesState> emit,
  ) async {
    emit(state.copyWith(status: NoiseStatus.loading));
    await _fetchWithRetry(emit);
  }

  /// Pull-to-refresh: giữ data cũ trong khi đang tải mới
  Future<void> _onRefreshNoises(
    RefreshNoises event,
    Emitter<NoisesState> emit,
  ) async {
    await _fetchWithRetry(emit);
  }

  /// Fetch dữ liệu với auto-retry khi gặp lỗi mạng
  Future<void> _fetchWithRetry(Emitter<NoisesState> emit) async {
    for (int attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        final dataNoises = await _remoteDataRepo.getResources();
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
