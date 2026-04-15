extension TimeFormatting on int {
  String toTimer() {
    final minutes = this ~/ 60;
    final seconds = this % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  String toHour() {
    final hours = this ~/ 3600;
    final minutes = (this % 3600) ~/ 60;

    if (this > 3600) {
      return '$hours ${minutes.toString().padLeft(2, '0')}';
    } else {
      final totalMinutes = this ~/ 60;
      return totalMinutes.toString();
    }
  }
}
