import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro/core/Theme/app_colors.dart';
import 'package:pomodoro/l10n/generated/app_localizations.dart';
import 'package:pomodoro/services/theme_storage_service.dart';
import 'package:pomodoro/ui/screens/settings/bloc/settings_bloc.dart';

import '../../../configs/di.dart';
import '../../commons/widgets/theme_background.dart';
import '../timer/bloc/timer_bloc.dart';

class HomeNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeNavigation({super.key, required this.navigationShell});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  String? _bgPath;
  String? _loadedThemeId;
  StreamSubscription<SettingsState>? _settingsSub;

  @override
  void initState() {
    super.initState();
    _loadBgPath();
  }

  @override
  void dispose() {
    _settingsSub?.cancel();
    super.dispose();
  }

  Future<void> _loadBgPath() async {
    final settingsBloc = DI.sl<SettingsBloc>();
    SettingsState settingsState = settingsBloc.state;

    // Wait until settings are loaded before reading theme-dependent assets.
    if (settingsState is! SuccessSettingState) {
      log('[HomeNavigation] Settings not ready, waiting for stream...');
      try {
        settingsState = await settingsBloc.stream
            .firstWhere((s) => s is SuccessSettingState)
            .timeout(const Duration(seconds: 10));
      } catch (e) {
        log('[HomeNavigation] Timeout waiting for settings', error: e);
        return;
      }
    }

    if (settingsState is SuccessSettingState) {
      final themeId = settingsState.settingsModel.selectedThemeId;
      log('[HomeNavigation] Settings loaded, themeId=$themeId');
      await _updateBgForTheme(themeId);
    }

    // Refresh background whenever selected theme changes.
    _settingsSub = settingsBloc.stream.listen((state) {
      if (state is SuccessSettingState) {
        final newThemeId = state.settingsModel.selectedThemeId;
        if (newThemeId != _loadedThemeId) {
          log('[HomeNavigation] Theme changed to: $newThemeId');
          _updateBgForTheme(newThemeId);
        }
      }
    });
  }

  Future<void> _updateBgForTheme(String themeId) async {
    if (themeId.isEmpty) {
      log('[HomeNavigation] themeId is empty, skipping');
      return;
    }
    final service = DI.sl<ThemeStorageService>();
    final path = await service.bgPathOf(themeId);
    final fileExists = File(path).existsSync();
    log('[HomeNavigation] bgPath=$path, exists=$fileExists');
    if (mounted && _loadedThemeId != themeId) {
      setState(() {
        _bgPath = path;
        _loadedThemeId = themeId;
      });
    }
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (prev, curr) => (prev.status == 1) != (curr.status == 1),
        builder: (context, state) {
          final bool isRunning = state.status == 1;
          return RepaintBoundary(
            child: AnimatedOpacity(
              // Nếu đang chạy (isRunning) thì mờ đi (0.0), nếu không thì hiện rõ (1.0)
              opacity: isRunning ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 500), // Thời gian mờ dần
              curve: Curves.easeInOut,
              child: NavigationBar(
                height: 56,
                elevation: 0,
                indicatorColor: Colors.transparent,
                selectedIndex: widget.navigationShell.currentIndex,
                onDestinationSelected: _onTap,
                backgroundColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                destinations: [
                  NavigationDestination(
                    icon: Icon(
                      Icons.timer_outlined,
                      color: AppColors.textSecondary,
                    ),
                    selectedIcon: Icon(Icons.timer, color: Colors.white),
                    label: AppLocalizations.of(context)!.timerTab,
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.stacked_bar_chart_rounded,
                      color: AppColors.textSecondary,
                    ),
                    selectedIcon: Icon(
                      Icons.stacked_bar_chart_rounded,
                      color: Colors.white,
                    ),
                    label: AppLocalizations.of(context)!.statisticsTab,
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.settings_outlined,
                      color: AppColors.textSecondary,
                    ),
                    selectedIcon: Icon(Icons.settings, color: Colors.white),
                    label: AppLocalizations.of(context)!.settingsTab,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      body: Stack(
        children: [
          RepaintBoundary(
            child: ThemeBackground(
              localImagePath: _bgPath,
              sigmaX: 0,
              sigmaY: 0,
              darkAlpha: 0.35,
            ),
          ),
          widget.navigationShell,
        ],
      ),
    );
  }
}
