import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:promodoro/data/models/daily_stat.dart';
import 'package:promodoro/utils/time_formatting.dart';

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
    if (widget.allStats.isEmpty || widget.onMonthChanged == null) return;
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;
    final centerIndex =
        ((offset + (_visibleBars * _barSlotWidth / 2)) / _barSlotWidth).floor();
    final clampedIndex = centerIndex.clamp(0, widget.allStats.length - 1);
    final stat = widget.allStats[clampedIndex];
    widget.onMonthChanged!(stat.date.year, stat.date.month);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.allStats.isEmpty) {
      return const Center(
        child: Text(
          'Chưa có dữ liệu',
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      );
    }

    final chartWidth = widget.allStats.length * _barSlotWidth;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth < _visibleBars * _barSlotWidth
              ? _visibleBars * _barSlotWidth
              : chartWidth,
          child: BarChart(mainBarData()),
        ),
      ),
    );
  }

  double get _maxY {
    final maxMinutes = widget.allStats
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
    return List.generate(widget.allStats.length, (i) {
      final stat = widget.allStats[i];
      return makeGroupData(
        i,
        stat.minutes.toDouble(),
        isTouched: i == touchedIndex,
      );
    });
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: 10,
          fitInsideVertically: true,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            if (group.x < 0 || group.x >= widget.allStats.length) return null;
            final stat = widget.allStats[group.x];
            return BarTooltipItem(
              (stat.minutes * 60).toHour(),
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
    if (index >= 0 && index < widget.allStats.length) {
      text = widget.allStats[index].dayOfMonth;
    }
    return SideTitleWidget(
      meta: meta,
      space: 12,
      child: Text(text, style: style),
    );
  }
}
