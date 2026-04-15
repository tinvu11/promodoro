class BackgroundTimerState {
  int endAtMs = 0;
  int initialDuration = 0;
  bool isRunning = false;
  int round = 1;
  int totalRounds = 1;
  String mode = 'work';
  int workDuration = 0;
  int breakDuration = 0;
  int remainingOnPause = 0;
  bool isUIForeground = true;
  String alarmWorkPath = '';
  String alarmBreakPath = '';
  double volumeWorkAlarm = 100.0;
  double volumeBreakAlarm = 100.0;
  String pauseLabel = 'Pause';

  String get currentLabel => mode == 'break' ? 'Break' : 'Focus';
  String get currentTimeMode => mode == 'break' ? 'break' : 'focus';

  int get remainingSeconds {
    if (!isRunning) return remainingOnPause;
    if (endAtMs == 0) return 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final diff = endAtMs - now;
    final sec = (diff + 999) ~/ 1000;
    return sec < 0 ? 0 : sec;
  }
}
