import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:promodoro/core/Theme/app_colors.dart';

class GlassBox extends StatelessWidget {
  final double? width;
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const GlassBox({
    super.key,
    this.width,
    required this.child,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.all(0.0),
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14.0, sigmaY: 14.0),
          child: Container(
            width: width,
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: AppColors.glassBorder, width: 1.0),
              gradient: AppColors.glassGradient,
              // color: Colors.white.withOpacity(0.1)
            ),
            child: RepaintBoundary(child: child),
          ),
        ),
      ),
    );
  }
}
