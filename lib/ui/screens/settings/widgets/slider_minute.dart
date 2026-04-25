import 'package:flutter/material.dart';
import 'package:pomodoro/l10n/generated/app_localizations.dart';

import '../../../../core/Theme/app_colors.dart';
import '../../../../core/Theme/app_fonts.dart';

class SliderMinute extends StatefulWidget {
  final int initialValue;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onIncrement;
  final ValueChanged<double>? onDecrement;

  const SliderMinute({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  State<SliderMinute> createState() => _SliderMinuteState();
}

class _SliderMinuteState extends State<SliderMinute> {
  late double _val;
  late double _displayVal;

  @override
  void initState() {
    super.initState();
    _val = widget.initialValue.toDouble();
    _displayVal = ((widget.initialValue) ~/ 5) * 5.0;
  }

  void _updateValues(double newValue) {
    setState(() {
      _val = newValue;
      // Cập nhật displayVal nếu nó là bội số của 5 để slider di chuyển mượt
      if (_val % 5 == 0) _displayVal = _val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
              icon: Icons.remove,
              onTap: () {
                if (_val > 5) {
                  _updateValues(_val - 1);
                  widget.onDecrement?.call(_val);
                }
              },
            ),
            Text(
              AppLocalizations.of(context)!.minutes(_val.toInt()),
              style: AppFonts.mediumWhite28,
            ),
            _buildActionButton(
              icon: Icons.add,
              onTap: () {
                if (_val < 180) {
                  _updateValues(_val + 1);
                  widget.onIncrement?.call(_val);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 25),
        Slider(
          value: _displayVal.clamp(1, 180),
          min: 1,
          max: 180,
          divisions: 36,
          inactiveColor: AppColors.glassPrimary,
          activeColor: AppColors.textPrimary,
          onChanged: (v) {
            setState(() {
              _val = v;
              _displayVal = v;
            });
          },
          onChangeEnd: (value) => widget.onChanged(value),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white70, size: 30),
    );
  }
}
