import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:promodoro/configs/di.dart';
import 'package:promodoro/core/Theme/app_fonts.dart';
import 'package:promodoro/navigation/app_router.dart';
import 'package:promodoro/services/noise_audio_service.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_bloc.dart';
import 'package:promodoro/ui/screens/timer/widgets/GlassTimerPage.dart';
import 'package:promodoro/utils/time_formatting.dart';

import '../../commons/widgets/common_appbar.dart';
import '../../commons/widgets/glass_box.dart';
import 'bloc/timer_bloc.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  TimerMode? _currentMode;
  late final NoiseAudioService _noiseAudioService;

  @override
  void initState() {
    super.initState();
    _noiseAudioService = DI.sl<NoiseAudioService>();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  @override
  void dispose() {
    // Dừng nhạc nền khi rời TimerPage
    _noiseAudioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Chỉ watch Settings vì nó ít khi thay đổi
    final settingsState = context.watch<SettingsBloc>().state;
    if (settingsState is! SuccessSettingState)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final settings = settingsState.settingsModel;

    return BlocListener<TimerBloc, TimerState>(
      listenWhen: (prev, curr) =>
          prev.runtimeType != curr.runtimeType || prev.mode != curr.mode,
      listener: (context, state) {
        // Tự động ẩn/hiện Status bar hệ thống
        if (state is TimerRunInProgress) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        } else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }

        // ── Quản lý nhạc nền (ambient noises) ──
        _handleNoiseAudio(state, settings);
      },

      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          final bool isRunning = state is TimerRunInProgress;

          return Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: isRunning
                ? null
                : _buildAppBar(context, settings.themeName),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  // 1. Khu vực hiển thị Timer (Đã tối ưu Rebuild)
                  GestureDetector(
                    onTap: () {
                      _onToggleTimer(context, state, settings);
                    },
                    child: _buildTimerDisplay(settings),
                  ),

                  const SizedBox(height: 100),

                  // isRunning ? SizedBox(height: 60,) : _buildControlButtons(context, settings),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimerDisplay(settingsModel) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, curr) =>
          prev.duration != curr.duration || prev.mode != curr.mode,
      builder: (context, state) {
        final int currentSeconds = state is TimerInitial
            ? settingsModel.workTime
            : state.duration;
        final initialDuration = state is TimerInitial
            ? settingsModel.workTime
            : state.initialDuration;

        double progress = initialDuration > 0
            ? currentSeconds / initialDuration
            : 0.0;
        String modeText =
            (state is TimerInitial || state.mode == TimerMode.work)
            ? "Work"
            : "Break";
        // String roundText = "${state.round} / ${state.totalRounds}";
        String roundText = "${state.round} / ${settingsModel.repeatCount}";

        return Stack(
          alignment: Alignment.center,
          children: [
            GlassTimer(size: 280, progress: progress.clamp(0.0, 1.0)),

            // Text Mode và Round
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(true ? Icons.pause : Icons.play_arrow, color: Colors.white,size: 30,),
                    Text(
                      modeText,
                      style: AppFonts.medium_white_20.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                Text(roundText, style: AppFonts.medium_white_20),
              ],
            ),

            // Số giây chính giữa
            Text(
              currentSeconds.toTimer(),
              style: AppFonts.semibold_white_40.copyWith(
                fontSize: 60,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildControlButtons(BuildContext context, settings) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        String textButton = "Bắt đầu";
        if (state is TimerRunPause) {
          textButton = "Tiếp tục";
        } else if (state is TimerRunInProgress) {
          textButton = "Tạm dừng";
        }

        final isRunning = state is TimerRunInProgress;
        final isInitial = state is TimerInitial;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nút Start/Pause
            GestureDetector(
              onTap: () => _onToggleTimer(context, state, settings),
              child: GlassBox(
                borderRadius: 216,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isRunning ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                      // const SizedBox(width: 8),
                      // Text(isRunning ? "Tạm dừng" : "Bắt đầu", style: AppFonts.medium_white_20),
                    ],
                  ),
                ),
              ),
            ),

            // Nút Reset (Chỉ hiện khi không ở trạng thái Initial)
            // if (!isInitial) ...[
            //   const SizedBox(width: 20),
            //   GestureDetector(
            //     onTap: () => context.read<TimerBloc>().add(const TimerReset()),
            //     child: const GlassBox(
            //       borderRadius: 26,
            //       child: Padding(
            //         padding: EdgeInsets.all(12.0),
            //         child: Icon(Icons.refresh, color: Colors.white),
            //       ),
            //     ),
            //   ),
            // ]
          ],
        );
      },
    );
  }

  // Gom nhóm logic xử lý sự kiện
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

  void _handleModeChange(TimerState state) {
    if (state is TimerRunInProgress && _currentMode != state.mode) {
      _currentMode = state.mode;
      // Có thể thêm rung hoặc âm thanh ngắn ở đây qua FlutterVibrate
    }
  }

  /// Quản lý nhạc nền (ambient noises) theo trạng thái timer.
  ///
  /// - Work + Running → phát loop
  /// - Pause → tạm dừng
  /// - Break / Complete / Reset → dừng hoàn toàn
  void _handleNoiseAudio(TimerState state, settings) {
    if (!settings.isSoundEnabled) {
      _noiseAudioService.stop();
      return;
    }

    if (state is TimerRunInProgress && state.mode == TimerMode.work) {
      // Đang work → phát nhạc nền
      if (!_noiseAudioService.isPlaying) {
        _noiseAudioService.play(
          volume: settings.volumeNoise,
          themeId: settings.selectedThemeId,
        );
      }
    } else if (state is TimerRunPause) {
      // Tạm dừng timer → tạm dừng nhạc nền
      _noiseAudioService.pause();
    } else {
      // Break mode, Complete, Reset → dừng hoàn toàn
      _noiseAudioService.stop();
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String themeId) {
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
                  const Icon(Icons.palette, color: Colors.white, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    themeId,
                    style: AppFonts.regular_grey_14.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
