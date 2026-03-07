extension TimeFormatting on int {
  String toTimer() {
    final minutes = this ~/ 60;
    final seconds = this % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  String toHour() {
    // 1. Tính toán các thành phần cơ bản
    final hours = this ~/ 3600;
    final minutes = (this % 3600) ~/ 60;

    // 2. Logic: Lớn hơn 60 phút (tức là từ 3601 giây trở đi)
    if (this > 3600) {
      // Hiển thị dạng: 1h 2m
      return '${hours} ${minutes.toString().padLeft(2, '0')}';
    } else {
      // 3. Logic: Nhỏ hơn hoặc bằng 60 phút
      // Tính tổng số phút (bao gồm cả trường hợp đúng 60 phút)
      final totalMinutes = this ~/ 60;

      // Nếu bạn chỉ muốn hiện mỗi số phút (VD: "60", "45")
      return totalMinutes.toString();

      // HOẶC nếu bạn muốn hiện cả giây (VD: "10:05") như comment của bạn:
      // return '${totalMinutes}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
