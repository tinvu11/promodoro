import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promodoro/ui/screens/settings/widgets/sectionwrapper.dart';

import '../../../../core/Theme/app_colors.dart';
import '../../../../core/Theme/app_fonts.dart';
import '../../../../navigation/app_router.dart';
import '../bloc/settings_bloc.dart';

class SystemSection extends StatelessWidget {
  const SystemSection({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      // Tối ưu GPU cho hiệu ứng Glass
      child: SectionWrapper(
        children: [
          BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (p, c) {
              if (p is! SuccessSettingState || c is! SuccessSettingState) return false;
              return p.settingsModel.alwaysOnScreen != c.settingsModel.alwaysOnScreen;
            },
            builder: (context, state) {
              state as SuccessSettingState;
              final settingsModel = state.settingsModel;
              return Column(
                children: [
                  _buildSimpleTile(context, "Ngôn ngữ", "Tiếng Việt", onTap: () => context.push(RoutePaths.language)),
                  const Divider(color: AppColors.glassSecondary, height: 1, indent: 16, endIndent: 16),
                  _buildSwitchTile("Luôn bật màn hình", settingsModel.alwaysOnScreen, (val) {
                    context.read<SettingsBloc>().add(SaveSettingsEvent(alwaysOnScreen: val));
                  }),
                  const Divider(color: AppColors.glassSecondary, height: 1, indent: 16, endIndent: 16),
                  _buildSimpleTile(context, "Thông tin", ""),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(title, style: AppFonts.medium_white_20),
      trailing: Switch(
        value: value,
        activeThumbColor: AppColors.textPrimary,
        activeTrackColor: AppColors.glassPrimary,
        inactiveThumbColor: AppColors.textSecondary,
        inactiveTrackColor: AppColors.glassSecondary,
        trackOutlineWidth: WidgetStateProperty.all(0),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSimpleTile(BuildContext context, String title, String value, {VoidCallback? onTap}) {
    return Theme(
      data: Theme.of(
        context,
      ).copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent, hoverColor: Colors.transparent),
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: AppFonts.medium_white_20),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: AppFonts.regular_grey_18),
            const SizedBox(width: 4),
            Icon(Icons.navigate_next, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
