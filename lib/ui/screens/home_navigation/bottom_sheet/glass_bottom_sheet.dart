import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pomodoro/core/Theme/app_fonts.dart';

class GlassBottomSheet extends StatelessWidget {
  final Widget child;
  final String title;
  const GlassBottomSheet({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(30),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 25.0,
          sigmaY: 25.0,
        ), // Độ mờ cao hơn cho Bottom Sheet
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Tự co giãn theo nội dung
            children: [
              // Thanh kéo (Handlebar) cho Bottom Sheet
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(title, style: AppFonts.regularGrey22),
              const SizedBox(height: 28),
              child,
              const SizedBox(height: 40), // Khoảng đệm dưới cùng cho an toàn
            ],
          ),
        ),
      ),
    );
  }
}
