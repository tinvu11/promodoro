import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promodoro/core/Theme/app_fonts.dart';
import 'package:promodoro/navigation/app_router.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_bloc.dart';
import 'package:promodoro/ui/screens/timer/widgets/GlassTimerPage.dart';
import 'package:promodoro/utils/time_formatting.dart';
import '../../../core/Theme/app_colors.dart';
import '../../commons/widgets/common_appbar.dart';
import '../../commons/widgets/glass_box.dart';
import 'bloc/timer_bloc.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  TimerMode? _currentMode;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch states
    final settingsState = context.watch<SettingsBloc>().state;
    final timerState = context.watch<TimerBloc>().state;

    if (settingsState is! SuccessSettingState) return const SizedBox();

    // Configuration from Settings (Convert minutes to seconds)
    final int workDuration = settingsState.settingsModel.workTime;
    final int breakDuration = settingsState.settingsModel.breakTime;
    final int totalRounds = settingsState.settingsModel.repeatCount;

    // Determine values for UI
    final int currentSeconds = (timerState is TimerInitial)
        ? workDuration
        : timerState.duration;

    final int initialDuration = (timerState is TimerInitial)
        ? workDuration
        : timerState.initialDuration;

    // Progress Calculation
    double progress = initialDuration > 0
        ? currentSeconds / initialDuration
        : 0.0;

    if (progress > 1.0) progress = 1.0;
    if (progress < 0.0) progress = 0.0;

    // Display Text
    String modeText = "Ready";
    if (timerState is! TimerInitial) {
       modeText = (timerState.mode == TimerMode.work) ? "Work" : "Break";
    } else {
       modeText = "Work"; // Default show Work
    }

    // Round Text
    String roundText = "${timerState.round} / ${timerState.totalRounds}";
    if (timerState is TimerInitial) {
       roundText = "1 / $totalRounds";
    }

    return BlocListener<TimerBloc, TimerState>(
      listener: (context, state) async {
        if (state is TimerInitial) return;

        // Initialize mode tracker if null
        _currentMode ??= state.mode;

        // Detect completion or mode switch
        if (state is TimerRunComplete) {
            // Finished final round (Work)
             await _playAlarm(settingsState.settingsModel.alarmWork.path);
        } else if (state is TimerRunInProgress) {
             // Check if mode changed
             if (_currentMode != state.mode) {
                // Determine what JUST finished
                if (_currentMode == TimerMode.work && state.mode == TimerMode.breakMode) {
                    // Work finished, Break started
                    await _playAlarm(settingsState.settingsModel.alarmWork.path);
                } else if (_currentMode == TimerMode.breakMode && state.mode == TimerMode.work) {
                    // Break finished, Work started
                    await _playAlarm(settingsState.settingsModel.alarmBreak.path);
                }
                _currentMode = state.mode;
             }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: CommonAppBar(
          showLeading: false,
          actions: [
            GestureDetector(
              onTap: () => context.push(RoutePaths.noises),
              child: GlassBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.music_note, color: AppColors.textSecondary, size: 16),
                      SizedBox(width: 5),
                      Text(settingsState.settingsModel.selectedThemeId, style: AppFonts.regular_grey_14),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Timer Circle
                  GlassTimer(size: 250, progress: progress),

                  // Static Texts (Mode, Round) inside the circle
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(modeText, style: AppFonts.medium_white_20),
                      const SizedBox(height: 80), // Gap where Time text sits
                      Text(roundText, style: AppFonts.medium_white_20),
                    ],
                  ),

                  // Countdown Time Text
                  Text(
                    currentSeconds.toTimer(),
                    style: AppFonts.semibold_white_40.copyWith(fontSize: 54),
                  ),
                ],
              ),

              const SizedBox(height: 120),

              // Control Button
              GestureDetector(
                onTap: () {
                  final timerBloc = context.read<TimerBloc>();
                  if (timerState is TimerInitial) {
                    // Reset current mode when starting
                    _currentMode = TimerMode.work;
                    timerBloc.add(TimerStarted(
                      workDuration: workDuration,
                      breakDuration: breakDuration,
                      totalRounds: totalRounds,
                    ));
                  } else if (timerState is TimerRunInProgress) {
                    timerBloc.add(const TimerPaused());
                  } else if (timerState is TimerRunPause) {
                    timerBloc.add(const TimerResumed());
                  } else if (timerState is TimerRunComplete) {
                    timerBloc.add(const TimerReset());
                  }
                },
                child: GlassBox(
                  borderRadius: 26,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          (timerState is TimerRunInProgress) ? Icons.pause : Icons.play_arrow,
                          color: AppColors.textSecondary,
                          size: 26,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          (timerState is TimerRunInProgress) ? "Tạm dừng" : "Bắt đầu",
                          style: AppFonts.medium_grey_20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _playAlarm(String assetPath) async {
    // Determine path. assetPath is assuming 'assets/alarm/filename.mp3'
    // AssetSource needs path relative to assets/ ?? No, AssetSource takes path from assets root or internal?
    // 'AssetSource' in audioplayers 6.0: "Represents a file in the assets directory".
    // If path is "assets/alarm/alarm1.mp3", AssetSource should handle it?
    // Usually AssetSource("alarm/alarm1.mp3") if configured in pubspec?
    // Let's strip 'assets/' prefix if present to be safe, as AssetSource prepends it or looks in root.
    // Actually, AssetSource prepends 'assets/' by default in some versions or looks for it.
    // Let's check how ConfigSection did it: AssetSource(path.replaceFirst('assets/', ''))
    
    final cleanPath = assetPath.startsWith('assets/') ? assetPath.replaceFirst('assets/', '') : assetPath;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(cleanPath));
    } catch (e) {
      debugPrint("Error playing alarm: $e");
    }
  }
}
