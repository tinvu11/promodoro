import 'package:flutter/material.dart';

import '../../../core/Theme/app_colors.dart';
import '../../commons/widgets/background.dart';
import '../../commons/widgets/common_appbar.dart';
import '../../commons/widgets/glass_box.dart';

class LanguagesPage extends StatelessWidget {
  const LanguagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: "Ngôn ngữ",
        actions: [
          GlassBox(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.check_rounded,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          const RepaintBoundary(
            child: Background(
              image: 'assets/images/bird.webp',
              sigmaX: 20,
              sigmaY: 20,
              darkAlpha: 0.35,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _itemLanguage("Tiếng Việt"),
                      _itemLanguage("Tiếng Anh"),
                      _itemLanguage("Tiếng Hàn"),
                      _itemLanguage("Tiếng Nhật"),
                      _itemLanguage("Tiếng Trung"),
                      _itemLanguage("Tiếng Thái"),
                      _itemLanguage("Tiếng Đức"),
                      _itemLanguage("Tiếng Tây Ban nha"),
                      _itemLanguage("Tiếng Việt"),
                      _itemLanguage("Tiếng Anh"),
                      _itemLanguage("Tiếng Hàn"),
                      _itemLanguage("Tiếng Nhật"),
                      _itemLanguage("Tiếng Trung"),
                      _itemLanguage("Tiếng Thái"),
                      _itemLanguage("Tiếng Đức"),
                      _itemLanguage("Tiếng Tây Ban nha"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemLanguage(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title, style: TextStyle(fontSize: 18))],
      ),
    );
  }
}
