import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:promodoro/core/Theme/app_fonts.dart';
import 'package:promodoro/navigation/app_router.dart';
import 'package:promodoro/ui/screens/timer/widgets/GlassTimerPage.dart';
import 'package:promodoro/utils/time_formatting.dart';
import '../../../core/Theme/app_colors.dart';
import '../../commons/widgets/common_appbar.dart';
import '../../commons/widgets/glass_box.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 300));
  }

  void _toggleTimer() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      if (_controller.value == 0) _controller.value = 12.0;
      _controller.reverse(from: _controller.value == 0 ? 1.0 : _controller.value);
    }
    setState(() {
      isStarted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Text('Thác nước', style: AppFonts.regular_grey_14),
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
            // Tách child trong column ra khỏi build để không phải build lại nhiều lần
            AnimatedBuilder(
              animation: _controller,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Work", style: AppFonts.medium_white_20),
                  const SizedBox(height: 80),
                  Text("2 / 5", style: AppFonts.medium_white_20),
                ],
              ),
              builder: (context, staticChild) {
                final int remainingSeconds = (_controller.duration!.inSeconds * (1 - _controller.value)).ceil();
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    GlassTimer(size: 250, progress: _controller.value),
                    staticChild!,
                    Text(remainingSeconds.toTimer(), style: AppFonts.semibold_white_40.copyWith(fontSize: 54)),
                  ],
                );
              },
            ),

            const SizedBox(height: 120),
            GestureDetector(
              onTap: _toggleTimer,
              child: GlassBox(
                borderRadius: 26,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isStarted && _controller.isAnimating ? Icons.pause : Icons.play_arrow,
                        color: AppColors.textSecondary,
                        size: 26,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isStarted && _controller.isAnimating ? "Tạm dừng" : "Bắt đầu",
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
    );
  }
}
