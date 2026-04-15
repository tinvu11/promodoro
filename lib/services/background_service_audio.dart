part of 'background_service.dart';


final AudioPlayer _audioPlayer = AudioPlayer();

Future<void> _playAlarm(String assetPath, double volumePercent) async {
  if (assetPath.isEmpty) return;

  final cleanPath = assetPath.startsWith('assets/')
      ? assetPath
      : 'assets/$assetPath';
  try {
    // When main app is killed, setAsset() might fail to find the Flutter Asset Bundle.
    // To ensure playback in headless isolate, we copy it to a temp file first.
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${cleanPath.replaceAll('/', '_')}');

    if (!await file.exists()) {
      final byteData = await rootBundle.load(cleanPath);
      await file.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );
    }

    await _audioPlayer.stop();
    await _audioPlayer.setVolume(volumePercent / 100.0);
    await _audioPlayer.setFilePath(file.path);
    await _audioPlayer.play();
  } catch (e) {
    debugPrint("Error playing alarm in background: $e");
  }
}

/// Plays an alarm and waits for completion (or timeout) before returning.
Future<void> _playAlarmAndWait(String assetPath, double volumePercent) async {
  if (assetPath.isEmpty) return;

  final completer = Completer<void>();
  StreamSubscription? sub;

  // Safety timeout in case completion event is never emitted.
  final timer = Timer(const Duration(seconds: 10), () {
    if (!completer.isCompleted) completer.complete();
  });

  sub = _audioPlayer.playerStateStream.listen((state) {
    if (state.processingState == ProcessingState.completed) {
      if (!completer.isCompleted) completer.complete();
    }
  });

  await _playAlarm(assetPath, volumePercent);
  await completer.future;

  timer.cancel();
  await sub.cancel();
}

Future<void> _disposeAudio() async {
  await _audioPlayer.dispose();
}

