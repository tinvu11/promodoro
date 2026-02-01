import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:promodoro/core/Theme/app_fonts.dart';
import 'package:promodoro/ui/commons/widgets/common_appbar.dart';
import '../../../core/Theme/app_colors.dart';
import '../../commons/widgets/background.dart';
import '../../commons/widgets/glass_box.dart';

class NoisesPage extends StatelessWidget {
  const NoisesPage({super.key});

  static const List<String> _musicList = [
    "assets/images/autu.jpg",
    "assets/images/nature.jpg",
    "assets/images/nature-2.jpg",
    "assets/images/bridge.jpg",
    "assets/images/gray.jpg",
    "assets/images/gum.jpg",
    "assets/images/leave.jpg",
    "assets/images/moss.jpg",
    "assets/images/mou.jpg",
    "assets/images/tree.jpg",
    "assets/images/trees.jpg",
    "assets/images/night.jpg",
    "assets/images/water.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: "Âm nền",
        actions: [
          GlassBox(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.check_rounded, color: AppColors.textSecondary, size: 22),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const RepaintBoundary(
            child: Background(image: 'assets/images/trees.jpg', sigmaX: 20, sigmaY: 20, darkAlpha: 0.35),
          ),
          SafeArea(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _musicList.length,
              // 4. Sử dụng cacheExtent để load trước các item sắp tới một cách mượt mà
              cacheExtent: 500,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                return _NoiseGridItem(imagePath: _musicList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NoiseGridItem extends StatelessWidget {
  final String imagePath;
  const _NoiseGridItem({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              // 5. Tối ưu cacheWidth: Chỉ load kích cỡ cần thiết (ví dụ 300px thay vì 500px)
              cacheWidth: 300,
              fit: BoxFit.cover,
              // Tối ưu hóa việc render frame đầu tiên
              filterQuality: FilterQuality.low,
            ),
          ),
        ),
        Positioned(left: 10, bottom: 10, child: Text('data', style: AppFonts.regular_white_16)),
      ],
    );
  }
}
