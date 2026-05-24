import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_web_admin_dashboard/common/app_colors.dart';
import 'package:flutter_erp/apps/flutter_web_admin_dashboard/common/common.dart';
import 'package:flutter_erp/apps/flutter_web_admin_dashboard/pages/dashboard/widget/setting_button.dart';

/*
Title:StatisticWidget 
Purpose:StatisticWidget
Created By:Kalpesh Khandla
Created Date:20 Feb 2022
*/

class StatisticWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: appContainerDecoration,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Statistic", style: TextStyle(color: AppColors.white)),
              SettingButton(),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 180,
            child: BarChart(
              mainBarData(),
              // swapAnimationDuration: animDuration,
            ),
          ),
        ],
      ),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      alignment: BarChartAlignment.center,
      barTouchData: BarTouchData(enabled: false),

      titlesData: FlTitlesData(
        show: true,

        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            getTitlesWidget: (value, meta) {
              return const Text('');
            },
          ),
        ),
      ),

      borderData: FlBorderData(show: false),
      groupsSpace: 4,
      barGroups: getData(),
    );
  }

  List<BarChartGroupData> getData() {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: 5.5, // antes y
            width: 40,
            rodStackItems: [
              BarChartRodStackItem(0, 3, Color(0xff8347f5)),
              BarChartRodStackItem(3, 4, Color(0xffeeb542)),
              BarChartRodStackItem(4, 5.5, Color(0xff62c79b)),
            ],
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: 4.5,
            width: 40,
            rodStackItems: [
              BarChartRodStackItem(0, 3, Color(0xffbe60f2)),
              BarChartRodStackItem(3, 4.5, Color(0xff4faeda)),
            ],
            borderRadius: BorderRadius.zero,
          ),
        ],
      ),
    ];
  }
}
