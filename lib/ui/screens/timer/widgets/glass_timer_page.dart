import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/Theme/app_colors.dart';

class GlassTimer extends StatelessWidget {
  final double size;
  final double progress;
  static const double _strokeWidth = 12.0;

  const GlassTimer({super.key, required this.size, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const _StaticGlassRing(strokeWidth: _strokeWidth),
            RepaintBoundary(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: progress, end: progress),
                duration: const Duration(seconds: 1),
                curve: Curves.linear,
                builder: (context, value, child) {
                  return _ProgressIndicator(
                    progress: value,
                    strokeWidth: _strokeWidth,
                    size: size,
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
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
