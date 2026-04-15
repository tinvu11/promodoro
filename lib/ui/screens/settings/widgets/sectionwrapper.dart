import 'package:flutter/material.dart';
import 'package:pomodoro/core/Theme/app_colors.dart';

import '../../../commons/widgets/glass_box.dart';

class SectionWrapper extends StatelessWidget {
  final List<Widget> children;
  const SectionWrapper({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassBox(
        child: Column(
          children: children.asMap().entries.map((e) {
            return Column(
              children: [
                e.value,
                if (e.key != children.length - 1)
                  const Divider(
                    color: AppColors.glassSecondary,
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
