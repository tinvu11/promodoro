import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promodoro/core/Theme/app_fonts.dart';
import 'package:promodoro/data/models/theme_model.dart';
import 'package:promodoro/ui/commons/widgets/common_appbar.dart';
import 'package:promodoro/ui/screens/noises/bloc/noises_bloc.dart';
import 'package:promodoro/ui/screens/noises/bloc/noises_state.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/Theme/app_colors.dart';
import '../../commons/widgets/background.dart';
import '../../commons/widgets/glass_box.dart';

class NoisesPage extends StatelessWidget {
  const NoisesPage({super.key});

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
              image: 'assets/images/trees.jpg',
              sigmaX: 20,
              sigmaY: 20,
              darkAlpha: 0.45,
            ),
          ),
          BlocBuilder<NoisesBloc, NoisesState>(
            builder: (BuildContext context, state) {
              if (state.status == NoiseStatus.loading) {
                return SafeArea(child: _buildShimmerGrid());
              } else if (state.status == NoiseStatus.success) {
                final data = state.themes;
                return SafeArea(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: data.length,
                    cacheExtent: 500,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.0,
                        ),
                    itemBuilder: (context, index) {
                      return _NoiseGridItem(theme: data[index], index: index);
                    },
                  ),
                );
              } else if (state.status == NoiseStatus.error) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off_rounded,
                          color: AppColors.textSecondary,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.errorMessage ?? 'Đã xảy ra lỗi',
                          style: AppFonts.regular_white_16,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  /// Shimmer grid placeholder khi đang loading
  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.white.withValues(alpha: 0.1),
          highlightColor: Colors.white.withValues(alpha: 0.25),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}

class _NoiseGridItem extends StatelessWidget {
  final ThemeModel theme;
  final int index;

  const _NoiseGridItem({required this.theme, required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Ảnh với fade-in animation
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: theme.imageUrl,
              fit: BoxFit.cover,
              memCacheWidth: 400,
              maxWidthDiskCache: 600,
              filterQuality: FilterQuality.medium,

              // Shimmer placeholder khi đang tải ảnh
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.white.withValues(alpha: 0.1),
                highlightColor: Colors.white.withValues(alpha: 0.25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Fade-in khi ảnh load xong
              fadeInDuration: const Duration(milliseconds: 300),
              fadeOutDuration: const Duration(milliseconds: 150),

              // Widget hiển thị khi lỗi
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_rounded,
                      color: Colors.white54,
                      size: 32,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Lỗi tải ảnh',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Gradient overlay để text đọc rõ hơn
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
                stops: [0.5, 1.0],
              ),
            ),
          ),
        ),

        // Tên theme
        Positioned(
          left: 10,
          bottom: 10,
          right: 10,
          child: Text(
            theme.name,
            style: AppFonts.regular_white_16,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
