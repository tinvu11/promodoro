import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:promodoro/core/Theme/app_fonts.dart';
import 'package:promodoro/navigation/app_router.dart';
import 'package:promodoro/ui/commons/widgets/common_appbar.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_bloc.dart';
import 'package:promodoro/ui/screens/settings/bloc/settings_state.dart';
import '../../../core/Theme/app_colors.dart';
import '../../../data/models/settings_model.dart';
import '../home_navigation/bottom_sheet/glass_bottom_sheet.dart';
import '../../commons/widgets/glass_box.dart';
import 'bloc/settings_event.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _expandedIndex = -1; // -1: không cái nào mở, 0: Work, 1: Break

  void _toggleExpanded(int index) {
    setState(() {
      _expandedIndex = (_expandedIndex == index) ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const CommonAppBar(title: "Settings", showLeading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (BuildContext context, state) {
              final settingsModel = state.settingsModel;
              return Column(
                children: [
                  // --- NHÓM 1: CẤU HÌNH POMODORO ---
                  _buildSection(
                    children: [
                      _buildExpandableTile(
                        title: "Thời gian làm việc",
                        value: "${settingsModel.workTime} phút",
                        isExpanded: _expandedIndex == 0,
                        onTap: () => _toggleExpanded(0),
                        children: [
                          _buildSubTile(
                            "Thời lượng",
                            "${settingsModel.workTime} phút",
                            () => _showSlider(
                              context,
                              settingsModel.workTime,
                              "Tập trung",
                              (newValue) {
                                final newSettings = settingsModel.copyWith(workTime: newValue.toInt());
                                context.read<SettingsBloc>().add(SaveSettingsEvent(settingsModel: newSettings));
                              },
                              (newValue) {
                                final newSettings = settingsModel.copyWith(workTime: newValue.toInt());
                                context.read<SettingsBloc>().add(SaveSettingsEvent(settingsModel: newSettings));
                              },
                              (newValue) {
                                final newSettings = settingsModel.copyWith(workTime: newValue.toInt());
                                context.read<SettingsBloc>().add(SaveSettingsEvent(settingsModel: newSettings));
                              },
                            ),
                          ),
                          _buildSubTile(
                            "Âm báo",
                            settingsModel.alarmWork,
                            () => _showAlarmPicker(context, settingsModel, (index) {
                              final newSettings = settingsModel.copyWith(alarmWork: "$index alarm break");
                              context.read<SettingsBloc>().add(SaveSettingsEvent(settingsModel: newSettings));
                            }),
                          ),
                          _buildSubTile(
                            "Âm lượng",
                            "${settingsModel.volumeWorkAlarm}%",
                            () => _showSessionSlider(
                              context,
                              settingsModel.volumeWorkAlarm,
                              "Âm lượng",
                              (newValue) {
                                final newSettings = settingsModel.copyWith(volumeWorkAlarm: newValue);
                                context.read<SettingsBloc>().add(SaveSettingsEvent(settingsModel: newSettings));
                              },
                              100,
                              10,
                            ),
                          ),
                        ],
                      ),
                      _buildExpandableTile(
                        title: "Thời gian nghỉ",
                        value: "${settingsModel.breakTime} phút",
                        isExpanded: _expandedIndex == 1,
                        onTap: () => _toggleExpanded(1),
                        children: [
                          _buildSubTile(
                            "Thời lượng",
                            "${settingsModel.breakTime} phút",
                            () => _showSlider(
                              context,
                              settingsModel.breakTime,
                              "Nghỉ ngơi",
                              (newValue) {
                                final newSettings = settingsModel.copyWith(breakTime: newValue.toInt());
                                context.read<SettingsBloc>().add(SaveSettingsEvent(settingsModel: newSettings));
                              },
                              (newValue) {
                                final newSettings = settingsModel.copyWith(breakTime: newValue.toInt());
                                context.read<SettingsBloc>().add(SaveSettingsEvent(settingsModel: newSettings));
                              },
                              (newValue) {
                                final newSettings = settingsModel.copyWith(breakTime: newValue.toInt());
                                context.read<SettingsBloc>().add(SaveSettingsEvent(settingsModel: newSettings));
                              },
                            ),
                          ),
                          _buildSubTile(
                            "Âm báo",
                            settingsModel.alarmBreak,
                            () => _showAlarmPicker(context, settingsModel, (index) {
                              final newSettings = settingsModel.copyWith(alarmBreak: "$index alarm break");
                              context.read<SettingsBloc>().add(SaveSettingsEvent(settingsModel: newSettings));
                            }),
                          ),
                          _buildSubTile(
                            "Âm lượng",
                            "${settingsModel.volumeBreakAlarm}%",
                            () => _showSessionSlider(
                              context,
                              settingsModel.volumeBreakAlarm,
                              "Âm lượng",
                              (newValue) {
                                final newSettings = settingsModel.copyWith(volumeBreakAlarm: newValue);
                                context.read<SettingsBloc>().add(SaveSettingsEvent(settingsModel: newSettings));
                              },
                              100,
                              10,
                            ),
                          ),
                        ],
                      ),
                      _buildSimpleTile(
                        "Số lần lặp",
                        "${settingsModel.repeatCount} lần",
                        onTap: () => _showSessionSlider(
                          context,
                          settingsModel.repeatCount.toDouble(),
                          "Lần lặp",
                          (newValue) {
                            final newSettings = settingsModel.copyWith(repeatCount: newValue.toInt());
                            context.read<SettingsBloc>().add(SaveSettingsEvent(settingsModel: newSettings));
                          },
                          12,
                          12,
                        ),
                      ),
                    ],
                  ),

                  // --- NHÓM 2: ÂM THANH ---
                  _buildSection(
                    children: [
                      _buildSwitchTile("Âm thanh", settingsModel.isSoundEnabled, (val) {
                        final newSettings = settingsModel.copyWith(isSoundEnabled: val);
                        context.read<SettingsBloc>().add(SaveSettingsEvent(settingsModel: newSettings));
                      }),
                      _buildSimpleTile(
                        "Âm thanh nền",
                        settingsModel.selectedThemeId,
                        onTap: () => context.push(RoutePaths.noises),
                      ),
                      _buildVolumeSliderTile("Âm lượng", settingsModel.volumeNoise, (val) {
                        final newSettings = settingsModel.copyWith(volumeNoise: val);
                        context.read<SettingsBloc>().add(SaveSettingsEvent(settingsModel: newSettings));
                      }),
                    ],
                  ),

                  // --- NHÓM 3: HỆ THỐNG ---
                  _buildSection(
                    children: [
                      _buildSimpleTile("Ngôn ngữ", "Tiếng Việt", onTap: () => context.push(RoutePaths.language)),
                      _buildSwitchTile("Luôn bật màn hình", settingsModel.alwaysOnScreen, (val) {
                        final newSettings = settingsModel.copyWith(alwaysOnScreen: val);
                        context.read<SettingsBloc>().add(SaveSettingsEvent(settingsModel: newSettings));
                      }),
                      _buildSimpleTile("Thông tin", ""),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER NHỎ GỌN ---
  Widget _buildSection({required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassBox(
        width: double.infinity,
        child: Column(
          children: List.generate(children.length, (index) {
            return Column(
              children: [
                children[index],
                if (index != children.length - 1)
                  Divider(color: Colors.white.withOpacity(0.1), height: 1, indent: 16, endIndent: 16),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSimpleTile(String title, String value, {VoidCallback? onTap}) {
    return Theme(
      data: Theme.of(
        context,
      ).copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent, hoverColor: Colors.transparent),
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: AppFonts.medium_white_20),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: AppFonts.regular_grey_18),
            const SizedBox(width: 4),
            Icon(Icons.navigate_next, color: AppColors.textSecondary),
          ],
        ),
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
          child: isExpanded ? Column(children: [...children, const SizedBox(height: 8)]) : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildSubTile(String title, String value, VoidCallback onTap) {
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

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(title, style: AppFonts.medium_white_20),
      trailing: Switch(
        value: value,
        activeThumbColor: AppColors.textPrimary,
        activeTrackColor: AppColors.glassPrimary,

        inactiveThumbColor: AppColors.textSecondary,
        inactiveTrackColor: AppColors.glassSecondary,
        trackOutlineWidth: WidgetStateProperty.all(0),
        // trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildVolumeSliderTile(String title, double initialValue, ValueChanged<double> onChanged) {
    double value = initialValue;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppFonts.medium_white_20),
              Row(
                children: [
                  const Icon(Icons.volume_up, size: 20),
                  Expanded(
                    child: Slider(
                      value: value,
                      max: 100,
                      inactiveColor: AppColors.glassPrimary,
                      activeColor: AppColors.textPrimary,
                      onChanged: (v) {
                        setState(() => value = v);
                        onChanged(v);
                      },
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(right: 12.0), child: Text("${value.toInt()}%")),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // --- LOGIC HIỂN THỊ ---

  void _showSlider(
    BuildContext context,
    int val,
    String title,
    ValueChanged<double> onChanged,
    ValueChanged<double>? onIncrement,
    ValueChanged<double>? onDecrement,
  ) {
    _showGlassBottomSheet(context, _buildSettingSlider(val, onChanged, onIncrement, onDecrement), title);
  }

  void _showSessionSlider(
    BuildContext context,
    double val,
    String title,
    ValueChanged<double> onChanged,
    int maxValue,
    int divisionValue,
  ) {
    _showGlassBottomSheet(context, _buildSettingSliderSessions(val, onChanged, maxValue, divisionValue), title);
  }

  void _showAlarmPicker(BuildContext context, SettingsModel settingsModel, void Function(int index) onSelect) {
    _showGlassBottomSheet(
      context,
      _buildSettingSliderAlarm(settingsModel: settingsModel, onSelect: onSelect),
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

  Widget _buildSettingSlider(
    int initialValue,
    ValueChanged<double> onChanged,
    ValueChanged<double>? onIncrement,
    ValueChanged<double>? onDecrement,
  ) {
    double val = initialValue.toDouble();
    double displayVal = (initialValue ~/ 5) * 5.0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    if (val > 0) {
                      setState(() => --val);
                      if (val % 5 == 0) displayVal = val;
                      onDecrement?.call(val);
                    }
                  },
                  icon: const Icon(Icons.remove, color: Colors.white70, size: 30),
                ),
                Text("${val.toInt()} phút", style: AppFonts.medium_white_28),
                IconButton(
                  onPressed: () {
                    if (val < 180) {
                      setState(() => ++val);
                      if (val % 5 == 0) displayVal = val;
                      onIncrement?.call(val);
                    }
                  },
                  icon: const Icon(Icons.add, color: Colors.white70, size: 30),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Slider(
              value: displayVal,
              min: 0,
              max: 180,
              divisions: 36,
              inactiveColor: AppColors.glassPrimary,
              activeColor: AppColors.textPrimary,
              onChanged: (v) {
                setState(() {
                  val = v;
                  displayVal = v;
                });
                onChanged(v);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingSliderSessions(
    double initialValue,
    ValueChanged<double> onChanged,
    int maxValue,
    int divisionValue,
  ) {
    double value = initialValue;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${value.toInt()}", style: const TextStyle(color: Colors.white, fontSize: 35)),
            const SizedBox(height: 25),
            Slider(
              value: value,
              max: maxValue.toDouble(),
              divisions: divisionValue,
              inactiveColor: AppColors.glassPrimary,
              activeColor: AppColors.textPrimary,
              onChanged: (v) {
                setState(() {
                  value = v;
                });
                onChanged(v);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingSliderAlarm({required SettingsModel settingsModel, required void Function(int index) onSelect}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(4, (index) {
        return GestureDetector(
          onTap: () => onSelect(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.alarm, color: Colors.white, size: 22),
              title: Text("Happy", style: AppFonts.regular_white_20),
            ),
          ),
        );
      }),
    );
  }
}
