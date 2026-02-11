import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promodoro/core/Theme/app_fonts.dart';
import 'package:promodoro/ui/screens/static/bloc/static_bloc.dart';
import 'package:promodoro/ui/screens/static/widgets/static_bar_chart.dart';
import 'package:promodoro/utils/time_formatting.dart';

import '../../../core/Theme/app_colors.dart';
import '../../../data/models/daily_stat.dart';
import '../../commons/widgets/common_appbar.dart';
import '../../commons/widgets/glass_box.dart';

class StaticPage extends StatefulWidget {
  const StaticPage({super.key});

  @override
  State<StaticPage> createState() => _StaticPageState();
}

class _StaticPageState extends State<StaticPage> {
  int _visibleYear = DateTime.now().year;
  int _visibleMonth = DateTime.now().month;

  String get _monthLabel => '$_visibleMonth/$_visibleYear';

  String _totalMonthlyFormatted(List<DailyStat> allStats) {
    final monthStats = allStats.where(
      (s) => s.date.year == _visibleYear && s.date.month == _visibleMonth,
    );
    final totalMinutes = monthStats.fold(0, (sum, s) => sum + s.minutes);
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (hours > 0 && mins > 0) return '$hours giờ $mins phút';
    if (hours > 0) return '$hours giờ';
    return '$mins phút';
  }

  void _onMonthChanged(int year, int month) {
    if (year != _visibleYear || month != _visibleMonth) {
      setState(() {
        _visibleYear = year;
        _visibleMonth = month;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        title: "Thống kê",
        showLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              context.read<StaticBloc>().add(SeedSampleDataEvent());
            },
            child: const GlassBox(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.science,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              context.read<StaticBloc>().add(LoadStaticEvent());
            },
            child: const GlassBox(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.restart_alt,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<StaticBloc, StaticState>(
        builder: (context, state) {
          if (state is StaticLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is StaticError) {
            return Center(
              child: Text(state.message, style: AppFonts.regular_grey_16),
            );
          }
          if (state is StaticLoaded) {
            return Padding(
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
                              title: Text(
                                _monthLabel,
                                style: AppFonts.medium_white_22,
                              ),
                              trailing: Text(
                                "Tổng: ${_totalMonthlyFormatted(state.allStats)}",
                                style: AppFonts.regular_grey_16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Divider(color: AppColors.glassSecondary),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: StaticBarChart(
                                  allStats: state.allStats,
                                  onMonthChanged: _onMonthChanged,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GlassBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.calendar_month,
                                color: AppColors.textSecondary,
                              ),
                              title: Text(
                                "Hôm nay",
                                style: AppFonts.medium_white_18,
                              ),
                              subtitle: Text(
                                "${(state.todayStat.minutes * 60).toHour()} - ${state.todayStat.sessions} sessions",
                                style: AppFonts.regular_grey_16,
                              ),
                            ),
                            Divider(color: AppColors.glassSecondary),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.watch_later_outlined,
                                color: AppColors.textSecondary,
                              ),
                              title: Text(
                                "Tổng",
                                style: AppFonts.medium_white_18,
                              ),
                              subtitle: Text(
                                "${(state.totalMinutes * 60).toHour()} - ${state.totalSessions} sessions",
                                style: AppFonts.regular_grey_16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
