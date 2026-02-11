import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promodoro/data/models/alarm_model.dart';
import 'package:promodoro/ui/screens/settings/widgets/sectionwrapper.dart';
import 'package:promodoro/ui/screens/settings/widgets/slider_minute.dart';
import 'package:promodoro/ui/screens/settings/widgets/slider_sessions.dart';
import 'package:promodoro/utils/time_formatting.dart';

import '../../../../core/Theme/app_colors.dart';
import '../../../../core/Theme/app_fonts.dart';
import '../../../../data/models/settings_model.dart';
import '../../home_navigation/bottom_sheet/glass_bottom_sheet.dart';
import '../bloc/settings_bloc.dart';

class ConfigSection extends StatefulWidget {
  const ConfigSection({super.key});

  @override
  State<ConfigSection> createState() => ConfigSectionState();
}

class ConfigSectionState extends State<ConfigSection> {
  int _expandedIndex = -1;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toggleExpanded(int index) {
    setState(() => _expandedIndex = (_expandedIndex == index) ? -1 : index);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      // Tối ưu GPU cho hiệu ứng Glass
      child: SectionWrapper(
        children: [
          BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (p, c) {
              if (p is! SuccessSettingState || c is! SuccessSettingState)
                return false;
              return p.settingsModel.workTime != c.settingsModel.workTime ||
                  p.settingsModel.alarmWork != c.settingsModel.alarmWork ||
                  p.settingsModel.volumeWorkAlarm !=
                      c.settingsModel.volumeWorkAlarm;
            },

            builder: (context, state) {
              state as SuccessSettingState;
              final settingsModel = state.settingsModel;
              return _buildExpandableTile(
                title: "Thời gian làm việc",
                value: settingsModel.workTime.toMinute(),
                isExpanded: _expandedIndex == 0,
                onTap: () => _toggleExpanded(0),
                children: [
                  _buildSubTile(
                    context,
                    "Thời lượng",
                    settingsModel.workTime.toMinute(),
                    () => _showSlider(
                      context,
                      settingsModel.workTime ~/ 60,
                      "Tập trung",
                      (newValue) {
                        context.read<SettingsBloc>().add(
                          SaveSettingsEvent(workTime: newValue.toInt() * 60),
                        );
                      },
                      (newValue) {
                        context.read<SettingsBloc>().add(
                          SaveSettingsEvent(workTime: newValue.toInt() * 60),
                        );
                      },
                      (newValue) {
                        context.read<SettingsBloc>().add(
                          SaveSettingsEvent(workTime: newValue.toInt() * 60),
                        );
                      },
                    ),
                  ),
                  _buildSubTile(
                    context,
                    "Âm báo",
                    settingsModel.alarmWork.name,
                    () => _showAlarmPicker(
                      context,
                      settingsModel,
                      settingsModel.alarmWork.id,
                      (alarm) {
                        context.read<SettingsBloc>().add(
                          SaveSettingsEvent(alarmWork: alarm),
                        );
                      },
                    ),
                  ),
                  _buildSubTile(
                    context,
                    "Âm lượng",
                    "${settingsModel.volumeWorkAlarm.toInt()}%",
                    () => _showSessionSlider(
                      context: context,
                      initialValue: settingsModel.volumeWorkAlarm,

                      onChanged: (newValue) {
                        context.read<SettingsBloc>().add(
                          SaveSettingsEvent(volumeWorkAlarm: newValue),
                        );
                      },
                      maxValue: 100,
                      minValue: 0,
                      divisions: 10,
                      title: 'Âm lượng',
                    ),
                  ),
                ],
              );
            },
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (p, c) {
              if (p is! SuccessSettingState || c is! SuccessSettingState)
                return false;
              return p.settingsModel.breakTime != c.settingsModel.breakTime ||
                  p.settingsModel.alarmBreak != c.settingsModel.alarmBreak ||
                  p.settingsModel.volumeBreakAlarm !=
                      c.settingsModel.volumeBreakAlarm;
            },

            builder: (context, state) {
              state as SuccessSettingState;
              final settingsModel = state.settingsModel;
              return _buildExpandableTile(
                title: "Thời gian nghỉ",
                value: settingsModel.breakTime.toMinute(),
                isExpanded: _expandedIndex == 1,
                onTap: () => _toggleExpanded(1),
                children: [
                  _buildSubTile(
                    context,
                    "Thời lượng",
                    settingsModel.breakTime.toMinute(),
                    () => _showSlider(
                      context,
                      settingsModel.breakTime ~/ 60,
                      "Nghỉ ngơi",
                      (newValue) {
                        context.read<SettingsBloc>().add(
                          SaveSettingsEvent(breakTime: newValue.toInt() * 60),
                        );
                      },
                      (newValue) {
                        context.read<SettingsBloc>().add(
                          SaveSettingsEvent(breakTime: newValue.toInt() * 60),
                        );
                      },
                      (newValue) {
                        context.read<SettingsBloc>().add(
                          SaveSettingsEvent(breakTime: newValue.toInt() * 60),
                        );
                      },
                    ),
                  ),
                  _buildSubTile(
                    context,
                    "Âm báo",
                    settingsModel.alarmBreak.name,
                    () => _showAlarmPicker(
                      context,
                      settingsModel,
                      settingsModel.alarmBreak.id,
                      (alarm) {
                        context.read<SettingsBloc>().add(
                          SaveSettingsEvent(alarmBreak: alarm),
                        );
                      },
                    ),
                  ),
                  _buildSubTile(
                    context,
                    "Âm lượng",
                    "${settingsModel.volumeBreakAlarm.toInt()}%",
                    () => _showSessionSlider(
                      context: context,
                      initialValue: settingsModel.volumeBreakAlarm,

                      onChanged: (newValue) {
                        context.read<SettingsBloc>().add(
                          SaveSettingsEvent(volumeBreakAlarm: newValue),
                        );
                      },
                      maxValue: 100,
                      minValue: 0,
                      divisions: 10,
                      title: 'Âm lượng',
                    ),
                  ),
                ],
              );
            },
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (p, c) {
              if (p is! SuccessSettingState || c is! SuccessSettingState)
                return false;
              return p.settingsModel.repeatCount != c.settingsModel.repeatCount;
            },
            builder: (context, state) {
              state as SuccessSettingState;
              final settingsModel = state.settingsModel;
              return _buildSimpleTile(
                "Số lần lặp",
                "${settingsModel.repeatCount} lần",
                onTap: () => _showSessionSlider(
                  initialValue: settingsModel.repeatCount.toDouble(),
                  title: "Lần lặp",
                  onChanged: (newValue) {
                    context.read<SettingsBloc>().add(
                      SaveSettingsEvent(repeatCount: newValue.toInt()),
                    );
                  },
                  maxValue: 12,
                  minValue: 1,
                  divisions: 11,
                  context: context,
                ),
              );
            },
          ),
          // Các phần khác tương tự...
        ],
      ),
    );
  }

  Widget _buildExpandableTile({
    required String title,
    required String value,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        _buildSimpleTile(title, value, onTap: onTap),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Column(children: [...children, const SizedBox(height: 8)])
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildSubTile(
    BuildContext context,
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppFonts.regular_grey_18),
            Text(value, style: AppFonts.regular_grey_18),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleTile(String title, String value, {VoidCallback? onTap}) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: AppFonts.medium_white_20),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: AppFonts.regular_grey_18),
            const SizedBox(width: 4),
            const Icon(Icons.navigate_next, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showSlider(
    BuildContext context,
    int val,
    String title,
    ValueChanged<double> onChanged,
    ValueChanged<double>? onIncrement,
    ValueChanged<double>? onDecrement,
  ) {
    _showGlassBottomSheet(
      context,
      SliderMinute(
        initialValue: val,
        onChanged: onChanged,
        onIncrement: onIncrement,
        onDecrement: onDecrement,
      ),
      title,
    );
  }

  void _showSessionSlider({
    required BuildContext context,
    required double initialValue,
    required String title,
    required ValueChanged<double> onChanged,
    required int maxValue,
    required int minValue,
    required int divisions,
  }) {
    _showGlassBottomSheet(
      context,
      SliderSessions(
        initialValue: initialValue,
        maxValue: maxValue,
        minValue: minValue,
        divisions: divisions,
        onChanged: onChanged,
      ),
      title,
    );
  }

  void _showAlarmPicker(
    BuildContext context,
    SettingsModel settingsModel,
    String currentSelection,
    void Function(AlarmModel path) onSelect,
  ) {
    _showGlassBottomSheet(
      context,
      _buildSettingAlarm(
        currentSelection: currentSelection,
        onSelect: onSelect,
      ),
      "Âm báo",
    );
  }

  void _showGlassBottomSheet(BuildContext context, Widget child, String title) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => GlassBottomSheet(child: child, title: title),
    );
  }

  Widget _buildSettingAlarm({
    required String currentSelection,
    required void Function(AlarmModel alarmModel) onSelect,
  }) {
    return FutureBuilder<List<AlarmModel>>(
      future: _getAlarmsFromJson(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final alarms = snapshot.data!;
        return Column(
          children: alarms.map((alarm) {
            final isSelected = currentSelection == alarm.id;
            return GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                onSelect(alarm);
                await _audioPlayer.stop();
                await _audioPlayer.play(
                  AssetSource(alarm.path.replaceFirst('assets/', '')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Container(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: Icon(
                      Icons.music_note,
                      color: AppColors.textPrimary,
                      size: 22,
                    ),
                    trailing: Icon(
                      isSelected ? Icons.check : null,
                      color: AppColors.textPrimary,
                      size: 22,
                    ),
                    title: Text(
                      alarm.name,
                      style: isSelected
                          ? AppFonts.medium_white_20
                          : AppFonts.regular_white_20,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Future<List<AlarmModel>> _getAlarmsFromJson() async {
    final String jsonString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/json/alarms.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((item) => AlarmModel.fromJson(item)).toList();
  }
}
