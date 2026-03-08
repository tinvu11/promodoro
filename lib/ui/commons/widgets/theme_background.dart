import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../services/theme_storage_service.dart';

/// Widget hiển thị ảnh nền theo chiến lược Offline-first.
///
/// Nếu [localImagePath] tồn tại trên disk → dùng `Image.file`.
/// Nếu không → fallback về [fallbackAsset] trong assets/.
class ThemeBackground extends StatelessWidget {
  /// Đường dẫn tuyệt đối đến ảnh nền local (VD: .../theme/active_bg.webp).
  final String? localImagePath;

  /// Asset path mặc định khi chưa có file local.
  final String fallbackAsset;
  final double sigmaX;
  final double sigmaY;
  final double darkAlpha;

  const ThemeBackground({
    super.key,
    this.localImagePath,
    this.fallbackAsset = ThemeStorageService.defaultBgAsset,
    this.sigmaX = 0,
    this.sigmaY = 0,
    this.darkAlpha = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    final bool useLocal =
        localImagePath != null && File(localImagePath!).existsSync();
    if (useLocal) {
      log('[ThemeBackground] Using local file: $localImagePath');
    } else {
      log('[ThemeBackground] Using fallback asset: $fallbackAsset');
    }

    return Stack(
      children: [
        Positioned.fill(
          child: useLocal
              ? Image.file(
                  File(localImagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    log(
                      '[ThemeBackground] Error loading local file, using fallback',
                      error: error,
                    );
                    return Image.asset(fallbackAsset, fit: BoxFit.cover);
                  },
                )
              : Image.asset(fallbackAsset, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
              child: Container(color: Colors.black.withOpacity(darkAlpha)),
            ),
          ),
        ),
      ],
    );
  }
}
