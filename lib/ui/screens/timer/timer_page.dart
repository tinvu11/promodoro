import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodoro/configs/di.dart';
import 'package:pomodoro/core/Theme/app_fonts.dart';
import 'package:pomodoro/data/data_sources/local_data.dart';
import 'package:pomodoro/data/models/settings_model.dart';
import 'package:pomodoro/l10n/generated/app_localizations.dart';
import 'package:pomodoro/navigation/app_router.dart';
import 'package:pomodoro/services/noise_audio_service.dart';
import 'package:pomodoro/services/theme_storage_service.dart';
import 'package:pomodoro/ui/screens/settings/bloc/settings_bloc.dart';
import 'package:pomodoro/ui/screens/timer/widgets/glass_timer_page.dart';
import 'package:pomodoro/utils/time_formatting.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
  late final NoiseAudioService _noiseAudioService;

  @override
  void initState() {
    super.initState();
    _noiseAudioService = DI.sl<NoiseAudioService>();
    _requestPermissions();
  }

  @override
  void dispose() {
    _noiseAudioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsBloc>().state;
    if (settingsState is! SuccessSettingState) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final settings = settingsState.settingsModel;

    return BlocListener<TimerBloc, TimerState>(
      listenWhen: (prev, curr) =>
          prev.runtimeType != curr.runtimeType || prev.mode != curr.mode,
      listener: (context, state) {
        if (state is TimerRunInProgress) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
            if (settings.alwaysOnScreen) WakelockPlus.enable();
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            WakelockPlus.disable();
          });
        }
        _handleNoiseAudio(state, settings);
      },

      child: BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (prev, curr) =>
            prev.runtimeType != curr.runtimeType ||
            (prev is TimerRunInProgress) != (curr is TimerRunInProgress),
        builder: (context, state) {
          final bool isRunning = state is TimerRunInProgress;

          return Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: RepaintBoundary(
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  offset: isRunning ? const Offset(0, -1) : Offset.zero,
                  child: _buildAppBar(context, settings),
                ),
              ),
            ),
            body: Center(
              child: Stack(
                children: [
                  RepaintBoundary(
                    child: GestureDetector(
                      onTap: () {
                        final currentState = context.read<TimerBloc>().state;
                        _onToggleTimer(context, currentState, settings);
                      },
                      child: _buildTimerDisplay(settings),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _requestPermissions() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Widget _buildTimerDisplay(SettingsModel settingsModel) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, curr) =>
          prev.runtimeType != curr.runtimeType ||
          prev.duration != curr.duration ||
          prev.mode != curr.mode,
      builder: (context, state) {
        final int currentSeconds =
            (state is TimerInitial || state is TimerRunComplete)
            ? settingsModel.workTime
            : state.duration;
        final initialDuration =
            (state is TimerInitial || state is TimerRunComplete)
            ? settingsModel.workTime
            : state.initialDuration;

        double progress = initialDuration > 0
            ? currentSeconds / initialDuration
            : 0.0;
        String modeText =
            (state is TimerInitial ||
                state.mode == TimerMode.work ||
                state is TimerRunComplete)
            ? AppLocalizations.of(context)!.work
            : AppLocalizations.of(context)!.breakLabel;
        String roundText = "${state.round} / ${settingsModel.repeatCount}";
        String roundBreakText =
            "${state.round} / ${settingsModel.repeatCount - 1}";

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
                      style: AppFonts.mediumWhite20.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                Text(
                  state.round > 0 && state.mode == TimerMode.breakMode
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
      },
    );
  }

  // Centralized start/pause/resume control for timer interactions.
  void _onToggleTimer(BuildContext context, TimerState state, settings) {
    final bloc = context.read<TimerBloc>();
    if (state is TimerInitial || state is TimerRunComplete) {
      bloc.add(
        TimerStarted(
          workDuration: settings.workTime,
          breakDuration: settings.breakTime,
          totalRounds: settings.repeatCount,
          alarmWorkPath: settings.alarmWork.path,
          alarmBreakPath: settings.alarmBreak.path,
          volumeWorkAlarm: settings.volumeWorkAlarm,
          volumeBreakAlarm: settings.volumeBreakAlarm,
        ),
      );
    } else if (state is TimerRunInProgress) {
      bloc.add(const TimerPaused());
    } else {
      bloc.add(const TimerResumed());
    }
  }

  /// Controls ambient noise playback based on timer state.
  void _handleNoiseAudio(TimerState state, settings) {
    if (!settings.isSoundEnabled) {
      _noiseAudioService.stop();
      return;
    }

    if (state is TimerRunInProgress && state.mode == TimerMode.work) {
      if (!_noiseAudioService.isPlaying) {
        _noiseAudioService.play(
          volume: settings.volumeNoise,
          themeId: settings.selectedThemeId,
        );
        debugPrint('\x1B[32m▶ [Timer] Timer đang chạy...\x1B[0m');
      }
    } else if (state is TimerRunPause) {
      debugPrint('Timer tam dung');
      _noiseAudioService.pause();
    } else {
      debugPrint("Timer ket thuc");
      _noiseAudioService.stop();
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
        SizedBox(width: 8),
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
