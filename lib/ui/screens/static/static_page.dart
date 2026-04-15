import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomodoro/core/Theme/app_fonts.dart';
import 'package:pomodoro/l10n/generated/app_localizations.dart';
import 'package:pomodoro/ui/screens/static/bloc/static_bloc.dart';
import 'package:pomodoro/ui/screens/static/widgets/static_bar_chart.dart';

import '../../../core/Theme/app_colors.dart';
import '../../../data/models/daily_stat.dart';
import '../../bloc/iap/iap_bloc.dart';
import '../../commons/widgets/banner_ad_widget.dart';
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

  String _totalMonthlyFormatted(
    List<DailyStat> allStats,
    AppLocalizations l10n,
  ) {
    final monthStats = allStats.where(
      (s) => s.date.year == _visibleYear && s.date.month == _visibleMonth,
    );
    final totalMinutes = monthStats.fold(0, (sum, s) => sum + s.minutes);
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (hours > 0 && mins > 0) return l10n.hoursAndMinutes(hours, mins);
    if (hours > 0) return l10n.hoursOnly(hours);
    return l10n.minutesOnly(mins);
  }

  String _todayFormated(AppLocalizations l10n, int time) {
    final hours = time ~/ 3600;
    final minutes = (time % 3600) ~/ 60;

    if (time > 3600) {
      return l10n.hoursAndMinutes(hours, minutes);
    } else {
      final totalMinutes = time ~/ 60;
      return l10n.minutes(totalMinutes);
    }
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
    final isPremium = context.watch<IapBloc>().state.boughtNoAdsTime != null;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        title: l10n.statistics,
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
              child: Text(state.message, style: AppFonts.regularGrey16),
            );
          }
          if (state is StaticLoaded) {
            return SizedBox(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(overscroll: false),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BannerAdWidget(
                        isPremium: isPremium,
                        paddingHorizontal: 16,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GlassBox(
                          child: SizedBox(
                            height: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                ListTile(
                                  horizontalTitleGap: 12,
                                  leading: Icon(
                                    Icons.calendar_month,
                                    color: AppColors.textSecondary,
                                  ),
                                  title: Text(
                                    _monthLabel,
                                    style: AppFonts.mediumWhite20,
                                  ),
                                  trailing: Text(
                                    l10n.totalLabel(
                                      _totalMonthlyFormatted(
                                        state.allStats,
                                        l10n,
                                      ),
                                    ),
                                    style: AppFonts.regularGrey16,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Divider(
                                    color: AppColors.glassSecondary,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
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
                      ),

                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),

                        child: GlassBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(
                                    Icons.calendar_today,
                                    color: AppColors.textSecondary,
                                  ),
                                  title: Text(
                                    l10n.today,
                                    style: AppFonts.mediumWhite18,
                                  ),
                                  subtitle: Text(
                                    "${_todayFormated(l10n, state.todayStat.minutes * 60)} - ${state.todayStat.sessions} ${l10n.sessions}",
                                    style: AppFonts.regularGrey16,
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
                                    l10n.total,
                                    style: AppFonts.mediumWhite18,
                                  ),
                                  subtitle: Text(
                                    " ${_todayFormated(l10n, state.totalMinutes * 60)} - ${state.totalSessions} ${l10n.sessions}",

                                    style: AppFonts.regularGrey16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
