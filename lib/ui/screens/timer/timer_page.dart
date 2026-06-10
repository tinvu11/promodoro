import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro/configs/di.dart';
import 'package:pomodoro/core/Theme/app_fonts.dart';
import 'package:pomodoro/data/data_sources/local_data.dart';
import 'package:pomodoro/data/models/settings_model.dart';
import 'package:pomodoro/l10n/generated/app_localizations.dart';
import 'package:pomodoro/navigation/app_router.dart';
import 'package:pomodoro/services/timer_background_service.dart';
import 'package:pomodoro/services/theme_storage_service.dart';
import 'package:pomodoro/ui/screens/settings/bloc/settings_bloc.dart';
import 'package:pomodoro/ui/screens/timer/widgets/glass_timer_page.dart';
import 'package:pomodoro/utils/time_formatting.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/Theme/app_colors.dart';
import '../../commons/widgets/common_appbar.dart';
import '../../commons/widgets/glass_box.dart';
import '../../commons/widgets/paywall_dialog.dart';
import 'bloc/timer_bloc.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
    PomodoroBackgroundService().initialize();
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsBloc>().state;
    if (settingsState is! SuccessSettingState) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final settings = settingsState.settingsModel;

    return MultiBlocListener(
      listeners: [
        BlocListener<TimerBloc, TimerState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == 1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.immersiveSticky,
                );
                if (settings.alwaysOnScreen) WakelockPlus.enable();
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                WakelockPlus.disable();
              });
            }
          },
        ),
        BlocListener<SettingsBloc, SettingsState>(
          listenWhen: (prev, curr) {
            if (prev is! SuccessSettingState || curr is! SuccessSettingState) {
              return false;
            }
            final prevSettings = prev.settingsModel;
            final currSettings = curr.settingsModel;
            return prevSettings.selectedThemeId !=
                    currSettings.selectedThemeId ||
                prevSettings.volumeNoise != currSettings.volumeNoise ||
                prevSettings.isSoundEnabled != currSettings.isSoundEnabled;
          },
          listener: (context, state) {
            // if (state is! SuccessSettingState) {
            //   debugPrint("Settings not loaded yet, skipping timer update");
            //   return;
            // }
            // ;
            // final timerState = context.read<TimerBloc>().state;
            // final isTimerActive = timerState.status == 0;
            // if (isTimerActive == false) return;
            // final updatedSettings = state.settingsModel;
            // _sendSettingsToTimer(context, updatedSettings);

            if (state is SuccessSettingState) {
              _sendSettingsToTimer(context, state.settingsModel);
            }
          },
        ),
      ],
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          final bool isRunning = state.status != 1;
          return Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: RepaintBoundary(
                child: IgnorePointer(
                  ignoring: state.status == 1,
                  child: AnimatedOpacity(
                    opacity: isRunning ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _buildAppBar(context, settings),
                  ),
                ),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      RepaintBoundary(
                        child: GestureDetector(
                          onTap: () {
                            _onToggleTimer(context, state, settings);
                          },
                          child: _buildTimerDisplay(context, state, settings),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  const SizedBox(height: 50),
                  AnimatedOpacity(
                    opacity: state.status == 2 ? 1.0 : 0.0, // Paused
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Opacity(
                          opacity: 0.0,
                          child: Icon(Icons.stop_outlined),
                        ),
                        const SizedBox(width: 30),
                        GestureDetector(
                          onTap: () {
                            if (state.status == 2) {
                              context.read<TimerBloc>().add(
                                PomodoroTimerReset(),
                              );
                            }
                          },
                          child: const Icon(Icons.stop_outlined),
                        ),
                        const SizedBox(width: 30),

                        GestureDetector(
                          onTap: () {
                            if (state.status == 2 &&
                                state.cycle < settings.repeatCount) {
                              context.read<TimerBloc>().add(
                                PomodoroTimerNext(),
                              );
                            }
                          },
                          child: Opacity(
                            opacity: state.cycle >= settings.repeatCount
                                ? 0.5
                                : 1.0,
                            child: const Icon(Icons.skip_next_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _sendSettingsToTimer(BuildContext context, SettingsModel settings) {
    context.read<TimerBloc>().add(
      PomodoroTimerSettingsUpdated({
        'workTime': settings.workTime,
        'breakTime': settings.breakTime,
        'repeatCount': settings.repeatCount,
        'isSoundEnabled': settings.isSoundEnabled,
        'alarmWorkPath': settings.alarmWork.path,
        'alarmBreakPath': settings.alarmBreak.path,
        'volumeWorkAlarm': settings.volumeWorkAlarm.toDouble(),
        'volumeBreakAlarm': settings.volumeBreakAlarm.toDouble(),
        'volumeNoise': settings.volumeNoise.toDouble(),
        'selectedThemeId': settings.selectedThemeId,
        'l10nFocus': AppLocalizations.of(context)!.work,
        'l10nBreak': AppLocalizations.of(context)!.breakLabel,
      }),
    );
  }

  Widget _buildTimerDisplay(
    BuildContext context,
    TimerState state,
    SettingsModel settingsModel,
  ) {
    final bool isWorkSession = state.session == 0;
    final int totalDuration = isWorkSession
        ? settingsModel.workTime
        : settingsModel.breakTime;
    final int currentSeconds = state.status == 0 || state.status == 3
        ? totalDuration
        : state.remainingSeconds;
    final double progress = totalDuration > 0
        ? currentSeconds / totalDuration
        : 0.0;
    final String modeText = isWorkSession
        ? AppLocalizations.of(context)!.work
        : AppLocalizations.of(context)!.breakLabel;
    String roundText = "${state.cycle} / ${settingsModel.repeatCount}";
    String roundBreakText = "${state.cycle} / ${settingsModel.repeatCount - 1}";

    return Stack(
      alignment: Alignment.center,
      children: [
        GlassTimer(size: 280, progress: progress.clamp(0.0, 1.0)),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  modeText,
                  style: AppFonts.mediumWhite20.copyWith(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 100),
            Text(
              state.cycle > 0 && state.session == 1
                  ? roundBreakText
                  : roundText,
              style: AppFonts.mediumWhite20,
            ),
          ],
        ),
        Text(
          currentSeconds.toTimer(),
          style: AppFonts.semiboldWhite40.copyWith(
            fontSize: 60,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Future<void> _requestPermissions() async {
    if (!mounted) return;
    await Future.delayed(const Duration(seconds: 1));
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  void _onToggleTimer(
    BuildContext context,
    TimerState state,
    SettingsModel settings,
  ) {
    final bloc = context.read<TimerBloc>();

    if (state.status == 0 || state.status == 3) {
      _sendSettingsToTimer(context, settings);
      bloc.add(PomodoroTimerStarted());
    } else if (state.status == 1) {
      bloc.add(PomodoroTimerPaused());
    } else if (state.status == 2) {
      bloc.add(PomodoroTimerResumed());
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, dynamic settings) {
    final langCode = Localizations.localeOf(context).languageCode;
    final cachedThemes = DI.sl<LocalData>().getCachedThemes();
    final theme = cachedThemes
        .where((t) => t.id == settings.selectedThemeId)
        .firstOrNull;
    final displayName =
        theme?.getLocalizedName(langCode) ??
        ThemeStorageService.getDefaultThemeName(langCode);
    return CommonAppBar(
      showLeading: false,
      actions: [
        GestureDetector(
          onTap: () => context.push(RoutePaths.noises),
          child: GlassBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.music_note_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    displayName,
                    style: AppFonts.regularGrey14.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => PaywallDialog.show(context),
          child: GlassBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.workspace_premium,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
