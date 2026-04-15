import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro/l10n/generated/app_localizations.dart';
import 'package:pomodoro/services/locale_service.dart';
import 'package:pomodoro/ui/bloc/locale/locale_cubit.dart';
import 'package:pomodoro/ui/screens/settings/widgets/sectionwrapper.dart';

import '../../../../core/Theme/app_colors.dart';
import '../../../../core/Theme/app_fonts.dart';
import '../../../../navigation/app_router.dart';
import '../bloc/settings_bloc.dart';

class SystemSection extends StatelessWidget {
  const SystemSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      children: [
        BlocBuilder<SettingsBloc, SettingsState>(
          buildWhen: (p, c) {
            if (p is! SuccessSettingState || c is! SuccessSettingState) {
              return false;
            }
            return p.settingsModel.alwaysOnScreen !=
                c.settingsModel.alwaysOnScreen;
          },
          builder: (context, state) {
            state as SuccessSettingState;
            final settingsModel = state.settingsModel;
            final l10n = AppLocalizations.of(context)!;
            final currentLangCode = context
                .watch<LocaleCubit>()
                .currentLanguageCode;
            return Column(
              children: [
                _buildSimpleTile(
                  context,
                  l10n.language,
                  LocaleService.displayName(currentLangCode),
                  onTap: () => context.push(RoutePaths.language),
                ),
                const Divider(
                  color: AppColors.glassSecondary,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                _buildSwitchTile(
                  l10n.alwaysOnScreen,
                  settingsModel.alwaysOnScreen,
                  (val) {
                    context.read<SettingsBloc>().add(
                      SaveSettingsEvent(alwaysOnScreen: val),
                    );
                  },
                ),
                const Divider(
                  color: AppColors.glassSecondary,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                _buildSimpleTile(
                  context,
                  l10n.information,
                  "",
                  onTap: () => context.push(RoutePaths.infos),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      title: Text(title, style: AppFonts.mediumWhite20),
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

  Widget _buildSimpleTile(
    BuildContext context,
    String title,
    String value, {
    VoidCallback? onTap,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: AppFonts.mediumWhite20),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: AppFonts.regularGrey18),
            const SizedBox(width: 4),
            Icon(Icons.navigate_next, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
