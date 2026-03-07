import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/Theme/app_colors.dart';
import '../../screens/timer/bloc/timer_bloc.dart';

class StopDialog_2 extends StatefulWidget {
  final Widget childWidget;

  const StopDialog_2({super.key, required this.childWidget});

  @override
  State<StopDialog_2> createState() => _StopDialog_2State();

  static void show(BuildContext context, {required Widget childWidget}) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'Stop timer 2',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, anim1, anim2, child) {
        final curve = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: curve,
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
      pageBuilder: (context, anim1, anim2) {
        // Trả về chính StatelessWidget này
        return StopDialog_2(childWidget: childWidget);
      },
    );
  }
}

class _StopDialog_2State extends State<StopDialog_2> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.glassBorder, width: 1),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withAlpha(30),
                        Colors.white.withAlpha(15),
                      ],
                    ),
                  ),
                  child: widget.childWidget,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
