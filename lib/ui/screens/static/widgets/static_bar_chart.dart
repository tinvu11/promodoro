import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/data/models/daily_stat.dart';
import 'package:pomodoro/l10n/generated/app_localizations.dart';

class StaticBarChart extends StatefulWidget {
  final List<DailyStat> allStats;
  final void Function(int year, int month)? onMonthChanged;

  StaticBarChart({super.key, required this.allStats, this.onMonthChanged});

  final Color barBackgroundColor = Colors.white.withValues(alpha: 0.2);
  final Color barColor = Colors.white.withAlpha(180);
  final Color touchedBarColor = Colors.white;

  @override
  State<StatefulWidget> createState() => _StaticBarChartState();
}

class _StaticBarChartState extends State<StaticBarChart> {
  int touchedIndex = -1;
  late ScrollController _scrollController;
  static const double _barSlotWidth = 51.0;
  static const int _visibleBars = 7;
  bool _initialScrollDone = false;

  List<DailyStat> get _displayStats {
    if (widget.allStats.isEmpty) return const [];

    final normalized = <DateTime, DailyStat>{};
    for (final stat in widget.allStats) {
      final day = DateTime(stat.date.year, stat.date.month, stat.date.day);
      normalized[day] = stat;
    }

    final firstDay = normalized.keys.reduce((a, b) => a.isBefore(b) ? a : b);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (firstDay.isAfter(today)) {
      return normalized.values.toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    }

    final filled = <DailyStat>[];
    for (
      var day = firstDay;
      !day.isAfter(today);
      day = day.add(const Duration(days: 1))
    ) {
      final stat = normalized[day];
      filled.add(stat ?? DailyStat(date: day, minutes: 0, sessions: 0));
    }

    return filled;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _scrollToEnd();
  }

  @override
  void didUpdateWidget(covariant StaticBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.allStats.length != widget.allStats.length) {
      _initialScrollDone = false;
      _scrollToEnd();
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && !_initialScrollDone) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        _initialScrollDone = true;
        _notifyVisibleMonth();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    _notifyVisibleMonth();
  }

  void _notifyVisibleMonth() {
    final stats = _displayStats;
    if (stats.isEmpty || widget.onMonthChanged == null) return;
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;
    final centerIndex =
        ((offset + (_visibleBars * _barSlotWidth / 2)) / _barSlotWidth).floor();
    final clampedIndex = centerIndex.clamp(0, stats.length - 1);
    final stat = stats[clampedIndex];
    widget.onMonthChanged!(stat.date.year, stat.date.month);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stats = _displayStats;
    if (stats.isEmpty) {
      return Center(
        child: Text(
          l10n.noData,
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      );
    }

    final chartWidth = stats.length * _barSlotWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: (_barSlotWidth - 22) / 2,
              ),
              width: chartWidth < constraints.maxWidth
                  ? constraints.maxWidth
                  : chartWidth,
              child: BarChart(mainBarData()),
            ),
          ),
        );
      },
    );
  }

  double get _maxY {
    final maxMinutes = _displayStats
        .map((s) => s.minutes)
        .fold(0, (a, b) => a > b ? a : b);
    return maxMinutes > 0 ? maxMinutes.toDouble() : 60.0;
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: _maxY,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() {
    final stats = _displayStats;
    return List.generate(stats.length, (i) {
      final stat = stats[i];
      return makeGroupData(
        i,
        stat.minutes.toDouble(),
        isTouched: i == touchedIndex,
      );
    });
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

  BarChartData mainBarData() {
    final l10n = AppLocalizations.of(context)!;
    final stats = _displayStats;
    return BarChartData(
      alignment: BarChartAlignment.start,
      groupsSpace: _barSlotWidth - 22,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: 10,
          fitInsideVertically: true,
          fitInsideHorizontally: true,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            if (group.x < 0 || group.x >= stats.length) return null;
            final stat = stats[group.x];
            return BarTooltipItem(
              _todayFormated(l10n, stat.minutes * 60),
              const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            );
            // return BarTooltipItem(
            //   'Ngày ${stat.dayOfMonth}\n',
            //   const TextStyle(
            //     color: Colors.white,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 18,
            //   ),
            //   children: <TextSpan>[
            //     TextSpan(
            //       text: '${stat.minutes} phút',
            //       style: const TextStyle(
            //         color: Colors.white,
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ],
            // );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    final index = value.toInt();
    String text = '';
    final stats = _displayStats;
    if (index >= 0 && index < stats.length) {
      text = stats[index].dayOfMonth;
    }
    return SideTitleWidget(
      meta: meta,
      space: 12,
      child: Text(text, style: style),
    );
  }
}
