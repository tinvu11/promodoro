import 'dart:developer';
import 'dart:io';

import 'package:just_audio/just_audio.dart';

import 'theme_storage_service.dart';

class NoiseAudioService {
  final ThemeStorageService _themeStorageService;
  final AudioPlayer _player = AudioPlayer();

  // Dùng trực tiếp getter của thư viện, không dùng biến cờ tự tạo
  bool get isPlaying => _player.playing;

  NoiseAudioService({required ThemeStorageService themeStorageService})
    : _themeStorageService = themeStorageService {
    _player.setLoopMode(LoopMode.one);
  }

  /// Khởi tạo và nạp file nhạc (Chỉ nên gọi khi đổi Theme hoặc bắt đầu Work)
  Future<void> initSource({
    required String themeId,
    required double volume,
  }) async {
    try {
      final audioPath = await _themeStorageService.audioPathOf(themeId);
      final file = File(audioPath);

      await _player.setVolume(volume / 100.0);

      if (await file.exists()) {
        await _player.setFilePath(audioPath);
      } else {
        await _player.setAsset('assets/noises/bird.ogg');
      }
    } catch (e) {
      log('[NoiseAudio] Init source failed', error: e);
    }
  }

  Future<void> play({required double volume, required String themeId}) async {
    try {
      final audioPath = await _themeStorageService.audioPathOf(themeId);
      final file = File(audioPath);

      // Set volume (just_audio dùng 0.0 → 1.0)
      await _player.setVolume(volume / 100.0);

      if (await file.exists()) {
        // Có file local → phát từ device
        await _player.setFilePath(audioPath);
        log(
          '[NoiseAudio] Started playing local: $audioPath (volume: ${volume.toStringAsFixed(0)}%)',
        );
      } else {
        // Không có file local → fallback về asset mặc định
        log('[NoiseAudio] No local audio at: $audioPath. Using default asset.');
        await _player.setAsset('assets/noises/bird.ogg');
        log(
          '[NoiseAudio] Started playing default asset (volume: ${volume.toStringAsFixed(0)}%)',
        );
      }
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (e, stackTrace) {
      log(
        '[NoiseAudio] Failed to play noises audio',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Sửa hàm pause: Bỏ check _isPlaying thủ công
  Future<void> pause() async {
    try {
      await _player.pause();
      log('\x1B[33m[NoiseAudio] Paused.\x1B[0m');
    } catch (e) {
      log('[NoiseAudio] Pause failed', error: e);
    }
  }

  /// Tiếp tục phát từ vị trí đã tạm dừng.
  Future<void> resume() async {
    try {
      await _player.play();
      log('[NoiseAudio] Resumed.');
    } catch (e) {
      log('[NoiseAudio] Failed to resume', error: e);
    }
  }

  /// Dừng hoàn toàn nhạc nền.
  Future<void> stop() async {
    try {
      await _player.stop();
      log('[NoiseAudio] Stopped.');
    } catch (e) {
      log('[NoiseAudio] Failed to stop', error: e);
    }
  }

  /// Cập nhật volume khi người dùng thay đổi trong Settings.
  Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume / 100.0);
      log('[NoiseAudio] Volume changed to ${volume.toStringAsFixed(0)}%');
    } catch (e) {
      log('[NoiseAudio] Failed to set volume', error: e);
    }
  }

  /// Dispose player khi service bị hủy.
  Future<void> dispose() async {
    await _player.dispose();
    log('[NoiseAudio] Disposed.');
  }
}
