import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:promodoro/core/Theme/app_fonts.dart';
import 'package:promodoro/navigation/app_router.dart';
import 'package:promodoro/ui/commons/widgets/common_appbar.dart';
import '../../../core/Theme/app_colors.dart';
import '../home_navigation/bottom_sheet/glass_bottom_sheet.dart';
import '../../commons/widgets/glass_box.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Sử dụng Enum hoặc ID để quản lý trạng thái mở rộng nếu số lượng mục tăng lên
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
          child: Column(
            children: [
              // --- NHÓM 1: CẤU HÌNH POMODORO ---
              _buildSection(
                children: [
                  _buildExpandableTile(
                    title: "Thời gian làm việc",
                    value: "25 phút",
                    isExpanded: _expandedIndex == 0,
                    onTap: () => _toggleExpanded(0),
                    children: [
                      _buildSubTile("Thời lượng", "25 phút", () => _showSlider(context, 25, "Tập trung")),
                      _buildSubTile("Âm báo", "Bird song", () => _showAlarmPicker(context)),
                      _buildSubTile("Âm lượng", "80%", () => _showSessionSlider(context, 8, "Âm lượng")),
                    ],
                  ),
                  _buildExpandableTile(
                    title: "Thời gian nghỉ",
                    value: "5 phút",
                    isExpanded: _expandedIndex == 1,
                    onTap: () => _toggleExpanded(1),
                    children: [
                      _buildSubTile("Thời lượng", "5 phút", () => _showSlider(context, 5, "Nghỉ ngơi")),
                      _buildSubTile("Âm báo", "Bird song", () => _showAlarmPicker(context)),
                      _buildSubTile("Âm lượng", "80%", () => _showSessionSlider(context, 8, "Âm lượng")),
                    ],
                  ),
                  _buildSimpleTile("Số lần lặp", "5 lần", onTap: () => _showSessionSlider(context, 4, "Lần lặp")),
                ],
              ),

              // --- NHÓM 2: ÂM THANH ---
              _buildSection(
                children: [
                  _buildSwitchTile("Âm thanh", false, (val) {}),
                  _buildSimpleTile("Âm thanh nền", "Mưa phùn", onTap: () => context.push(RoutePaths.noises)),
                  _buildVolumeSliderTile("Âm lượng", 60),
                ],
              ),

              // --- NHÓM 3: HỆ THỐNG ---
              _buildSection(
                children: [
                  _buildSimpleTile("Ngôn ngữ", "Tiếng Việt", onTap: () => context.push(RoutePaths.language)),
                  _buildSwitchTile("Luôn bật màn hình", true, (val) {}),
                  _buildSimpleTile("Thông tin", ""),
                ],
              ),
              const SizedBox(height: 20),
            ],
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

  Widget _buildVolumeSliderTile(String title, double value) {
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
                  onChanged: (v) {},
                ),
              ),
              Padding(padding: const EdgeInsets.only(right: 12.0), child: Text("${value.toInt()}%")),
            ],
          ),
        ],
      ),
    );
  }

  // --- LOGIC HIỂN THỊ ---

  void _showSlider(BuildContext context, double val, String title) {
    _showGlassBottomSheet(context, _buildSettingSlider(val), title);
  }

  void _showSessionSlider(BuildContext context, double val, String title) {
    _showGlassBottomSheet(context, _buildSettingSliderSessions(val), title);
  }

  void _showAlarmPicker(BuildContext context) {
    _showGlassBottomSheet(context, _buildSettingSliderAlarm(), "Âm báo");
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

  Widget _buildSettingSlider(double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.remove, color: Colors.white70, size: 30),
            Text("${value.toInt()} phút", style: AppFonts.medium_white_28),
            Icon(Icons.add, color: Colors.white70, size: 30),
          ],
        ),
        const SizedBox(height: 25),

        Slider(
          value: value,
          max: 180,
          divisions: 36,
          inactiveColor: AppColors.glassPrimary,
          activeColor: AppColors.textPrimary,
          onChanged: (v) {},
        ),
      ],
    );
  }

  Widget _buildSettingSliderSessions(double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${value.toInt()}", style: TextStyle(color: Colors.white, fontSize: 35)),
        const SizedBox(height: 25),
        Slider(
          value: value,
          max: 12,
          divisions: 12,
          inactiveColor: AppColors.glassPrimary,
          activeColor: AppColors.textPrimary,
          onChanged: (v) {},
        ),
      ],
    );
  }

  Widget _buildSettingSliderAlarm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.alarm, color: Colors.white, size: 22),
            title: Text("Happy", style: AppFonts.regular_white_20),
            trailing: Icon(Icons.check_rounded),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.alarm, color: Colors.white, size: 22),
            title: Text("Happy", style: AppFonts.regular_white_20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.alarm, color: Colors.white, size: 22),
            title: Text("Happy", style: AppFonts.regular_white_20),
          ),
        ),
      ],
    );
  }
}
