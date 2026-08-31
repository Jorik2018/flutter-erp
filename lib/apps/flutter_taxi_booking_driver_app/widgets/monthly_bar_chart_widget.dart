import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyYBarChartWidget extends StatelessWidget {
  const MonthlyYBarChartWidget({super.key});

  static const List<_ChartData> data = [
    _ChartData("JA", 10),
    _ChartData("F", 12),
    _ChartData("MAR", 30),
    _ChartData("A", 5),
    _ChartData("MAY", 44),
    _ChartData("JUN", 60),
    _ChartData("JUL", 46),
    _ChartData("AU", 0),
    _ChartData("S", 23),
    _ChartData("O", 99),
    _ChartData("N", 34),
    _ChartData("D", 78),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: 100,
          barGroups: List.generate(data.length, (index) {
            final item = data[index];

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item.value.toDouble(),
                  width: 14,
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
                    child: Text(
                      data[index].label,
                      style: const TextStyle(fontSize: 10),
                    ),
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
