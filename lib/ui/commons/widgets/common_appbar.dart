import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro/core/Theme/app_fonts.dart';

import '../../../core/Theme/app_colors.dart';

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
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: showLeading ? 0 : 20,
      leadingWidth: showLeading ? 56 : 0,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title:
          titleWidget ??
          (title != null ? Text(title!, style: AppFonts.mediumWhite28) : null),
      leading: showLeading ? (leading ?? _buildDefaultLeading(context)) : null,
      actions: [...?actions, const SizedBox(width: 16)],
    );
  }

  Widget _buildDefaultLeading(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onLeadingPressed ?? () => context.pop(),
        child: const SizedBox(
          height: 40,
          width: 40,
          child: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
