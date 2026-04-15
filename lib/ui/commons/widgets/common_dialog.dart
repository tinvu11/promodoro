import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/Theme/app_colors.dart';
import '../../../core/Theme/app_fonts.dart';
import '../../screens/timer/bloc/timer_bloc.dart';

class CommonDialog extends StatefulWidget {
  final VoidCallback onConfirm;
  final String title;
  final String content;
  final String rightTextBtn;
  final String leftTextBtn;

  const CommonDialog({
    super.key,
    required this.onConfirm,
    required this.title,
    required this.content,
    required this.leftTextBtn,
    required this.rightTextBtn,
  });

  @override
  State<CommonDialog> createState() => _CommonDialogState();

  static void show(
    BuildContext context, {
    required VoidCallback onConfirm,
    required String title,
    required String content,
    required rightTextBtn,
    required leftTextBtn,
  }) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'Stop timer',
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
        return CommonDialog(
          onConfirm: onConfirm,
          title: title,
          content: content,
          rightTextBtn: rightTextBtn,
          leftTextBtn: leftTextBtn,
        );
      },
    );
  }
}

class _CommonDialogState extends State<CommonDialog> {
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
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.title, style: AppFonts.mediumGrey22),
                        const SizedBox(height: 10),

                        Text(widget.content, style: AppFonts.regularGrey16),
                        const SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 90),

                            GestureDetector(
                              onTap: () => _cancel(context),
                              child: Text(
                                widget.leftTextBtn,
                                style: AppFonts.mediumGrey14.copyWith(
                                  decorationColor: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _stopTimer(onConfirm: widget.onConfirm);
                              },
                              child: Text(
                                widget.rightTextBtn,
                                style: AppFonts.mediumGrey14.copyWith(
                                  decorationColor: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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

  void _stopTimer({required VoidCallback onConfirm}) async {
    context.read<TimerBloc>().add(const TimerReset());
    Navigator.pop(context);
    onConfirm();
  }

  void _cancel(BuildContext context) {
    Navigator.pop(context);
  }
}
