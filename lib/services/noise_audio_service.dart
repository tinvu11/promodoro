import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';

import 'theme_storage_service.dart';

/// Service phát nhạc nền (ambient noises) khi timer đang chạy ở chế độ Work.
///
/// Chiến lược Offline-first:
///   - Nếu file `active_audio.mp3` tồn tại local → dùng `DeviceFileSource`
///   - Nếu không → dùng asset mặc định (hoặc không phát)
///
/// Audio phát loop liên tục, volume điều chỉnh theo `volumeNoise` từ Settings.
class NoiseAudioService {
  final ThemeStorageService _themeStorageService;
  final AudioPlayer _player = AudioPlayer();

  bool _isPlaying = false;

  NoiseAudioService({required ThemeStorageService themeStorageService})
    : _themeStorageService = themeStorageService {
    // Cấu hình loop vô hạn
    _player.setReleaseMode(ReleaseMode.loop);

    _player.onPlayerStateChanged.listen((state) {
      log('[NoiseAudio] Player state: $state');
    });

    _player.onLog.listen((msg) {
      log('[NoiseAudio] Player log: $msg');
    });
  }

  bool get isPlaying => _isPlaying;

  /// Bắt đầu phát nhạc nền.
  ///
  /// [volume] từ 0 → 100 (giá trị từ SettingsModel.volumeNoise)
  /// [themeId] ID của theme đang active (để lấy đúng file audio).
  Future<void> play({required double volume, required String themeId}) async {
    try {
      final audioPath = await _themeStorageService.audioPathOf(themeId);
      final file = File(audioPath);

      // Set volume (audioplayers dùng 0.0 → 1.0)
      await _player.setVolume(volume / 100.0);

      if (await file.exists()) {
        // Có file local → phát từ device
        await _player.play(DeviceFileSource(audioPath));
        log(
          '[NoiseAudio] Started playing local: $audioPath (volume: ${volume.toStringAsFixed(0)}%)',
        );
      } else {
        // Không có file local → fallback về asset mặc định
        log('[NoiseAudio] No local audio at: $audioPath. Using default asset.');
        await _player.play(AssetSource('noises/bird.ogg'));
        log(
          '[NoiseAudio] Started playing default asset (volume: ${volume.toStringAsFixed(0)}%)',
        );
      }
      _isPlaying = true;
    } catch (e, stackTrace) {
      log(
        '[NoiseAudio] Failed to play noises audio',
        error: e,
        stackTrace: stackTrace,
      );
      _isPlaying = false;
    }
  }

  /// Tạm dừng nhạc nền (giữ vị trí để resume).
  Future<void> pause() async {
    try {
      if (_isPlaying) {
        await _player.pause();
        _isPlaying = false;
        log('[NoiseAudio] Paused.');
      }
    } catch (e) {
      log('[NoiseAudio] Failed to pause', error: e);
    }
  }

  /// Tiếp tục phát từ vị trí đã tạm dừng.
  Future<void> resume() async {
    try {
      await _player.resume();
      _isPlaying = true;
      log('[NoiseAudio] Resumed.');
    } catch (e) {
      log('[NoiseAudio] Failed to resume', error: e);
    }
  }

  /// Dừng hoàn toàn nhạc nền.
  Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false;
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
    _isPlaying = false;
    log('[NoiseAudio] Disposed.');
  }
}
