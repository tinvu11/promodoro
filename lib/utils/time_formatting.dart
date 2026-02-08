extension TimeFormatting on int {
  String toTimer() {
    final minutes = this ~/ 60;
    final seconds = this % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
  // String toTimer() {
  //   final hours = this ~/ 3600; // 3600 giây = 1 giờ
  //   final minutes = (this % 3600) ~/ 60;
  //   final seconds = this % 60;
  //
  //   if (hours > 0) {
  //     // Trường hợp >= 60 phút: hiển thị dạng 1h : 10
  //     return '${hours}h : ${minutes.toString().padLeft(2, '0')}';
  //   } else {
  //     // Trường hợp < 60 phút: hiển thị dạng 10:05
  //     return '${minutes.toString().padLeft(2, '0')}:'
  //         '${seconds.toString().padLeft(2, '0')}';
  //   }
  // }
  String toMinute() {
    int minutes = this ~/ 60;
    return "$minutes phút";
  }
}
