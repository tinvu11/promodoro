import 'package:flutter/material.dart';
import 'package:promodoro/core/Theme/app_fonts.dart';
import 'package:promodoro/ui/screens/static/widgets/static_bar_chart.dart';
import '../../../core/Theme/app_colors.dart';
import '../../commons/widgets/common_appbar.dart';
import '../../commons/widgets/glass_box.dart';

class StaticPage extends StatelessWidget {
  const StaticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const CommonAppBar(
        title: "Thống kê",
        showLeading: false,
        actions: [
          GlassBox(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.restart_alt, color: AppColors.textSecondary, size: 22),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              GlassBox(
                child: SizedBox(
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ListTile(
                        title: Text('Tuần này', style: AppFonts.medium_white_20),
                        trailing: Text("Tổng: 3 giờ", style: AppFonts.regular_grey_16),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(color: AppColors.glassSecondary),
                      ),
                      Expanded(
                        child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: StaticBarChart()),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              GlassBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.calendar_month, color: AppColors.textSecondary),
                        title: Text("Hôm nay", style: AppFonts.medium_white_18),
                        subtitle: Text("0m - 0 sessions", style: AppFonts.regular_grey_16),
                      ),
                      Divider(color: AppColors.glassSecondary),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.watch_later_outlined, color: AppColors.textSecondary),
                        title: Text("Tổng", style: AppFonts.medium_white_18),
                        subtitle: Text("0m - 0 sessions", style: AppFonts.regular_grey_16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
