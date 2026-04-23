import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro/configs/di.dart';
import 'package:pomodoro/data/data_sources/local_data.dart';
import 'package:pomodoro/l10n/generated/app_localizations.dart';
import 'package:pomodoro/services/theme_storage_service.dart';
import 'package:pomodoro/ui/screens/settings/widgets/sectionwrapper.dart';

import '../../../../core/Theme/app_colors.dart';
import '../../../../core/Theme/app_fonts.dart';
import '../../../../navigation/app_router.dart';
import '../../../commons/widgets/stop_dialog.dart';
import '../../timer/bloc/timer_bloc.dart';
import '../bloc/settings_bloc.dart';

class SoundSection extends StatelessWidget {
  const SoundSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      children: [
        // Các phần khác tương tự...
        BlocBuilder<SettingsBloc, SettingsState>(
          buildWhen: (p, c) {
            if (p is! SuccessSettingState || c is! SuccessSettingState) {
              return false;
            }
            return p.settingsModel.isSoundEnabled !=
                    c.settingsModel.isSoundEnabled ||
                p.settingsModel.selectedThemeId !=
                    c.settingsModel.selectedThemeId ||
                p.settingsModel.volumeNoise != c.settingsModel.volumeNoise;
          },
          builder: (context, state) {
            state as SuccessSettingState;
            final settingsModel = state.settingsModel;
            final l10n = AppLocalizations.of(context)!;
            return Column(
              children: [
                _buildSwitchTile(l10n.sound, settingsModel.isSoundEnabled, (
                  val,
                ) {
                  context.read<SettingsBloc>().add(
                    SaveSettingsEvent(isSoundEnabled: val),
                  );
                }),
                const Divider(
                  color: AppColors.glassSecondary,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                _buildSimpleTile(
                  context,
                  l10n.backgroundSound,
                  () {
                    final langCode = Localizations.localeOf(
                      context,
                    ).languageCode;
                    final cachedThemes = DI.sl<LocalData>().getCachedThemes();
                    final theme = cachedThemes
                        .where((t) => t.id == settingsModel.selectedThemeId)
                        .firstOrNull;
                    return theme?.getLocalizedName(langCode) ??
                        ThemeStorageService.getDefaultThemeName(langCode);
                  }(),
                  onTap: () {
                    final timerState = context.read<TimerBloc>().state;
                    if (timerState.status == 1 || timerState.status == 2) {
                      StopDialog.show(
                        context,
                        onConfirm: () {
                          context.push(RoutePaths.noises);
                        },
                      );
                      return;
                    }
                    context.push(RoutePaths.noises);
                  },
                ),
                const Divider(
                  color: AppColors.glassSecondary,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                _buildVolumeSliderTile(l10n.volume, settingsModel.volumeNoise, (
                  val,
                ) {
                  context.read<SettingsBloc>().add(
                    SaveSettingsEvent(volumeNoise: val),
                  );
                }),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildVolumeSliderTile(
    String title,
    double initialValue,
    ValueChanged<double> onChanged,
  ) {
    double value = initialValue;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppFonts.mediumWhite20),
              Row(
                children: [
                  const Icon(Icons.volume_up, size: 20),
                  Expanded(
                    child: Slider(
                      value: value,
                      max: 100,
                      inactiveColor: AppColors.glassPrimary,
                      activeColor: AppColors.textPrimary,
                      onChanged: (v) {
                        setState(() => value = v);
                      },
                      onChangeEnd: (value) => onChanged(value),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Text("${value.toInt()}%"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
        // trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
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
