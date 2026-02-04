import 'package:flutter/material.dart';
import '../../../../core/Theme/app_fonts.dart';

class VolumeSlider extends StatefulWidget {
  final double initialValue;
  final String title;
  final ValueChanged<double> onSave;

  const VolumeSlider({super.key, required this.initialValue, required this.title, required this.onSave});

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: AppFonts.medium_white_20),
          Row(
            children: [
              const Icon(Icons.volume_up, size: 20, color: Colors.white),
              Expanded(
                child: Slider(
                  value: _currentValue,
                  max: 100,
                  onChanged: (v) => setState(() => _currentValue = v), // Update UI local cực nhanh
                  onChangeEnd: (v) => widget.onSave(v), // Chỉ lưu vào Database khi dừng kéo
                ),
              ),
              Text("${_currentValue.toInt()}%", style: AppFonts.regular_grey_18),
            ],
          ),
        ],
      ),
    );
  }
}
