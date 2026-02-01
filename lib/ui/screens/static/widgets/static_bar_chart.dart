import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:promodoro/core/Theme/app_fonts.dart';

import '../../../../core/Theme/app_colors.dart';

class StaticBarChart extends StatefulWidget {
  StaticBarChart({super.key});

  final Color barBackgroundColor = Colors.white.withValues(alpha: 0.2);
  final Color barColor = Colors.white.withAlpha(180);
  final Color touchedBarColor = Colors.white;

  @override
  State<StatefulWidget> createState() => StaticBarChartState();
}

class StaticBarChartState extends State<StaticBarChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BarChart(mainBarData());
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
          backDrawRodData: BackgroundBarChartRodData(show: true, toY: 20, color: widget.barBackgroundColor),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(
    7,
    (i) => switch (i) {
      0 => makeGroupData(0, 25, isTouched: i == touchedIndex),
      1 => makeGroupData(1, 6.5, isTouched: i == touchedIndex),
      2 => makeGroupData(2, 5, isTouched: i == touchedIndex),
      3 => makeGroupData(3, 7.5, isTouched: i == touchedIndex),
      4 => makeGroupData(4, 9, isTouched: i == touchedIndex),
      5 => makeGroupData(5, 11.5, isTouched: i == touchedIndex),
      6 => makeGroupData(6, 6.5, isTouched: i == touchedIndex),
      _ => throw Error(),
    },
  );

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: 10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay = switch (group.x) {
              0 => 'Monday',
              1 => 'Tuesday',
              2 => 'Wednesday',
              3 => 'Thursday',
              4 => 'Friday',
              5 => 'Saturday',
              6 => 'Sunday',
              _ => throw Error(),
            };
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              children: <TextSpan>[
                TextSpan(
                  text: ((rod.toY - 1).toStringAsFixed(1)).toString(),
                  style: const TextStyle(
                    color: Colors.white, //widget.touchedBarColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTitles, reservedSize: 38),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14);
    String text = switch (value.toInt()) {
      0 => 'M',
      1 => 'T',
      2 => 'W',
      3 => 'T',
      4 => 'F',
      5 => 'S',
      6 => 'S',
      _ => '',
    };
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: Text(text, style: style),
    );
  }
}
