import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:promodoro/core/Theme/app_fonts.dart';
import '../../../core/Theme/app_colors.dart';
import '../../commons/widgets/glass_box.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showLeading;
  final VoidCallback? onLeadingPressed;
  final double height;

  const CommonAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.showLeading = true,
    this.onLeadingPressed,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppBar(
        titleSpacing: showLeading ? 12 : 0,
        leadingWidth: 40,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: titleWidget ?? (title != null ? Text(title!, style: AppFonts.medium_white_28) : null),
        leading: showLeading ? (leading ?? _buildDefaultLeading(context)) : null,
        actions: actions?.map((action) => action).toList(),
      ),
    );
  }

  // Nút Back mặc định với phong cách GlassBox
  Widget _buildDefaultLeading(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onLeadingPressed ?? () => context.pop(),
        child: const SizedBox(
          height: 40,
          width: 40,
          child: GlassBox(child: Icon(Icons.arrow_back_ios_new, color: AppColors.textSecondary, size: 20)),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
