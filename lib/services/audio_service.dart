import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pomodoro/services/theme_storage_service.dart';

class PomodoroAudioService {
  final ThemeStorageService _themeStorageService;

  final AudioPlayer _noisePlayer = AudioPlayer();
  final AudioPlayer _alarmPlayer = AudioPlayer();

  String? _currentNoisePath;

  PomodoroAudioService({required ThemeStorageService themeStorageService})
    : _themeStorageService = themeStorageService {
    _noisePlayer.setLoopMode(LoopMode.one);
  }

  // --- PHẦN QUẢN LÝ NOISE (NHẠC NỀN) ---

  bool get isNoisePlaying => _noisePlayer.playing;

  Future<void> playNoise({
    required String themeId,
    required double volume,
  }) async {
    try {
      final audioPath = await _themeStorageService.audioPathOf(themeId);
      await _noisePlayer.setVolume(volume / 100.0);

      // Chỉ load lại file nếu theme thay đổi
      if (_currentNoisePath != audioPath) {
        final file = File(audioPath);
        if (await file.exists()) {
          await _noisePlayer.setFilePath(audioPath);
        } else {
          // Fallback về asset mặc định nếu không thấy file local
          await _noisePlayer.setAsset(ThemeStorageService.defaultAudioAsset);
        }
        _currentNoisePath = audioPath;
        await _noisePlayer.seek(Duration.zero);
      }

      await _noisePlayer.play();
      log('[AudioService] Playing noise: $themeId');
    } catch (e) {
      log('[AudioService] Play noise failed', error: e);
    }
  }

  Future<void> pauseNoise() async => await _noisePlayer.pause();

  Future<void> resumeNoise() async => await _noisePlayer.play();

  Future<void> stopNoise() async {
    await _noisePlayer.stop();
    _currentNoisePath = null;
  }

  Future<void> setNoiseVolume(double volume) async {
    await _noisePlayer.setVolume(volume / 100.0);
  }

  // --- PHẦN QUẢN LÝ ALARM (CHUÔNG BÁO) ---

  Future<void> playAlarm(String assetPath, double volume) async {
    if (assetPath.isEmpty) return;

    final cleanPath = assetPath.startsWith('assets/')
        ? assetPath
        : 'assets/$assetPath';
    try {
      // Vì Alarm thường là asset, ta copy ra file tạm để just_audio đọc ổn định hơn trong Background
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${cleanPath.replaceAll('/', '_')}');

      if (!await file.exists()) {
        final byteData = await rootBundle.load(cleanPath);
        await file.writeAsBytes(byteData.buffer.asUint8List());
      }

      await _alarmPlayer.stop();
      await _alarmPlayer.setVolume(volume / 100.0);
      await _alarmPlayer.setFilePath(file.path);
      await _alarmPlayer.play();
    } catch (e) {
      log('[AudioService] Play alarm failed', error: e);
    }
  }

  /// Phát chuông và đợi đến khi phát xong (Dùng cho logic kết thúc phiên)
  Future<void> playAlarmAndWait(String assetPath, double volume) async {
    if (assetPath.isEmpty) return;

    final completer = Completer<void>();
    StreamSubscription? sub;

    // Timeout an toàn 10s
    final timer = Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) completer.complete();
    });

    sub = _alarmPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (!completer.isCompleted) completer.complete();
      }
    });

    await playAlarm(assetPath, volume);
    await completer.future;

    timer.cancel();
    await sub.cancel();
  }

  // --- DISPOSE ---

  Future<void> dispose() async {
    await _noisePlayer.dispose();
    await _alarmPlayer.dispose();
    log('[AudioService] Disposed all players.');
  }
}
