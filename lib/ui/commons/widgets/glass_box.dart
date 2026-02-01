import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:promodoro/core/Theme/app_colors.dart';

class GlassBox extends StatelessWidget {
  final double? width;
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const GlassBox({
    Key? key,
    this.width,
    required this.child,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.all(0.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
        child: Container(
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppColors.glassBorder, width: 1.0),
            gradient: AppColors.glassGradient,
          ),
          child: child,
        ),
      ),
    );
  }
}
