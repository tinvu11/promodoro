import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/configs/di.dart';
import 'package:pomodoro/core/Theme/app_fonts.dart';
import 'package:pomodoro/l10n/generated/app_localizations.dart';
import 'package:pomodoro/services/locale_service.dart';
import 'package:pomodoro/services/theme_storage_service.dart';
import 'package:pomodoro/ui/bloc/locale/locale_cubit.dart';
import 'package:pomodoro/ui/commons/widgets/common_appbar.dart';
import 'package:pomodoro/ui/screens/settings/bloc/settings_bloc.dart';

import '../../../core/Theme/app_colors.dart';
import '../../commons/widgets/theme_background.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({super.key});

  @override
  State<LanguagesPage> createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  /// Resolved synchronously to avoid first-frame background flicker.
  String? _initialBgPath;

  @override
  void initState() {
    super.initState();

    final settingsState = context.read<SettingsBloc>().state;
    if (settingsState is SuccessSettingState) {
      final themeId = settingsState.settingsModel.selectedThemeId;
      if (themeId.isNotEmpty) {
        final service = DI.sl<ThemeStorageService>();
        _initialBgPath = service.bgPathOfSync(themeId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCubit = context.watch<LocaleCubit>();
    final currentCode = localeCubit.currentLanguageCode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(title: l10n.languageSelection),
      body: Stack(
        children: [
          RepaintBoundary(
            key: ValueKey(_initialBgPath ?? 'default'),
            child: ThemeBackground(
              localImagePath: _initialBgPath,
              sigmaX: 15,
              sigmaY: 15,
              darkAlpha: 0.55,
            ),
          ),
          SafeArea(
            child: SizedBox(
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: LocaleService.supportedLocales.map((locale) {
                      final code = locale.languageCode;
                      final isSelected = code == currentCode;
                      return _itemLanguage(
                        LocaleService.displayName(code),
                        isSelected: isSelected,
                        onTap: () {
                          context.read<LocaleCubit>().changeLocale(code);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _itemLanguage(
  String title, {
  bool isSelected = false,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppFonts.regularWhite18),
          if (isSelected)
            const Icon(
              Icons.check_rounded,
              color: AppColors.textPrimary,
              size: 24,
            ),
        ],
      ),
    ),
  );
}
