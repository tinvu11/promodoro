import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/Theme/app_colors.dart';

class GlassTimer extends StatefulWidget {
  final double size;
  final double progress; // Giá trị từ 1.0 về 0.0

  const GlassTimer({super.key, required this.size, required this.progress});

  @override
  State<GlassTimer> createState() => _GlassTimerState();
}

class _GlassTimerState extends State<GlassTimer> {
  double _oldProgress = 1.0;

  @override
  void didUpdateWidget(covariant GlassTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _oldProgress = oldWidget.progress;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const _StaticGlassRing(strokeWidth: 11),
            RepaintBoundary(
              child: TweenAnimationBuilder<double>(
                // QUAN TRỌNG: Chạy từ giá trị cũ đến giá trị mới
                tween: Tween<double>(begin: _oldProgress, end: widget.progress),
                duration: const Duration(seconds: 1),
                curve: Curves.linear, // Dùng linear để khớp với nhịp đếm giây
                builder: (context, value, child) {
                  return _ProgressIndicator(
                    progress: value,
                    strokeWidth: 11,
                    size: widget.size,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Các class bổ trợ (giữ nguyên logic của bạn nhưng sửa painter một chút) ---

class _StaticGlassRing extends StatelessWidget {
  final double strokeWidth;
  const _StaticGlassRing({required this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: RingClipper(strokeWidth),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.glassPrimary,
          ),
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final double progress;
  final double strokeWidth;
  final double size;

  const _ProgressIndicator({
    required this.progress,
    required this.strokeWidth,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: TimerPainter(progress: progress, strokeWidth: strokeWidth),
    );
  }
}

class RingClipper extends CustomClipper<Path> {
  final double strokeWidth;
  RingClipper(this.strokeWidth);

  @override
  Path getClip(Size size) {
    final outerPath = Path()
      ..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    final innerPath = Path()
      ..addOval(
        Rect.fromLTWH(
          strokeWidth,
          strokeWidth,
          size.width - strokeWidth * 2,
          size.height - strokeWidth * 2,
        ),
      );
    return Path.combine(PathOperation.difference, outerPath, innerPath);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TimerPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;

  TimerPainter({required this.progress, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    // Nếu progress quá nhỏ (gần bằng 0), ta có thể ép về 0 để tránh nét vẽ thừa
    if (progress <= 0.0001) return;

    Paint paint = Paint()
      ..color = AppColors.textPrimary
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double offset = strokeWidth / 2;
    Rect rect = Rect.fromLTWH(
      offset,
      offset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    // Vẽ từ đỉnh (-pi/2) đi hết vòng theo progress
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
