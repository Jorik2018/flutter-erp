import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ErningBarChartWidget extends StatelessWidget {
  const ErningBarChartWidget({super.key});

  static const List<_ChartData> data = [
    _ChartData("M", 10),
    _ChartData("TU", 12),
    _ChartData("W", 30),
    _ChartData("TH", 5),
    _ChartData("F", 66),
    _ChartData("SA", 60),
    _ChartData("SU", 100),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: 100,
          minY: 0,

          barGroups: List.generate(data.length, (index) {
            final item = data[index];

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item.value.toDouble(),
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),

          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }

                  return SideTitleWidget(
                    meta: meta,
                    child: Text(data[index].label),
                  );
                },
              ),
            ),
          ),

          borderData: FlBorderData(show: false),

          gridData: const FlGridData(show: false),
        ),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }
}

class _ChartData {
  final String label;
  final int value;

  const _ChartData(this.label, this.value);
}
