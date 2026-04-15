import 'dart:ui';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final String image;
  final double sigmaX;
  final double sigmaY;
  final double darkAlpha;
  const Background({
    super.key,
    required this.image,
    required this.sigmaX,
    required this.sigmaY,
    required this.darkAlpha,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
              child: Container(
                color: Colors.black.withValues(alpha: darkAlpha),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
