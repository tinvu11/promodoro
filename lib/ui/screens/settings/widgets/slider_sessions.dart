import 'package:flutter/material.dart';

import '../../../../core/Theme/app_colors.dart';

class SliderSessions extends StatefulWidget {
  final double initialValue;
  final int maxValue;
  final int divisions;
  final ValueChanged<double> onChanged;

  const SliderSessions({
    super.key,
    required this.initialValue,
    required this.maxValue,
    required this.divisions,
    required this.onChanged,
  });

  @override
  State<SliderSessions> createState() => _SliderSessionsState();
}

class _SliderSessionsState extends State<SliderSessions> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${_currentValue.toInt()}", style: const TextStyle(color: Colors.white, fontSize: 35)),
        const SizedBox(height: 25),
        Slider(
          value: _currentValue,
          max: widget.maxValue.toDouble(),
          divisions: widget.divisions,
          inactiveColor: AppColors.glassPrimary,
          activeColor: AppColors.textPrimary,
          onChanged: (v) {
            setState(() => _currentValue = v);
          },
          onChangeEnd: (v) => widget.onChanged(v),
        ),
      ],
    );
  }
}
