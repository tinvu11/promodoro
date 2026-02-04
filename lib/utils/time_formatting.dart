extension TimeFormatting on int {
  String toTimer() {
    final minutes = this ~/ 60;
    final seconds = this % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  String toMinute() {
    int minutes = this ~/ 60;
    return "$minutes phút";
  }
}
