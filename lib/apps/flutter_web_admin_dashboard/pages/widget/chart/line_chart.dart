import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_web_admin_dashboard/common/app_colors.dart';

class AppLineChart extends StatefulWidget {
  final List<FlSpot> spots;
  final Color barColor;

  const AppLineChart({
    Key? key,
    required this.spots,
    required this.barColor,
  }) : super(key: key);
  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<AppLineChart> {
@override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1(),
      duration: const Duration(milliseconds: 250), // antes swapAnimationDuration
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        handleBuiltInTouches: false,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) =>
              Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (event, response) {
          // nueva firma
        },
      ),

      gridData: FlGridData(show: false),

      titlesData: FlTitlesData(show: false),

      borderData: FlBorderData(show: false),

      minX: 0,
      maxX: 14,
      minY: 0,
      maxY: 4,

      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    return [
      LineChartBarData(
        spots: widget.spots,
        isCurved: true,

        gradient: LinearGradient(
          colors: [
            AppColors.transparent,
            widget.barColor,
          ],
        ),

        barWidth: 2,
        isStrokeCapRound: true,

        dotData: FlDotData(show: false),

        belowBarData: BarAreaData(show: false),
      ),
    ];
  }
}
