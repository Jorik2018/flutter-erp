import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_finance_app_ui/common/color_constants.dart';
import 'package:flutter_erp/apps/flutter_finance_app_ui/common/constants.dart';
import 'package:flutter_erp/apps/flutter_finance_app_ui/custom_widgets/graph_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final numberFormat = NumberFormat("##,###.00#", "en_US");
  Color color = ColorConstants.gblackColor;
  Color fcolor = ColorConstants.kgreyColor;
  bool isActive = false;
  int? activeIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kblackColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.short_text, color: ColorConstants.kwhiteColor),
                  Icon(Icons.more_vert, color: ColorConstants.kwhiteColor),
                ],
              ),
              SizedBox(height: 30),
              Text(
                "Your Balance",
                /*style: GoogleFonts.spartan(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.kwhiteColor,
                ),*/
              ),
              SizedBox(height: 20),
              Text(
                "Money Received",
                /*style: GoogleFonts.spartan(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.kgreyColor,
                ),*/
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    r'$' + "${numberFormat.format(27802.05)}",
                    style: GoogleFonts.openSans(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.kwhiteColor,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "15%",
                        /*style: GoogleFonts.spartan(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.kwhiteColor,
                        ),*/
                      ),
                      Icon(
                        Icons.arrow_upward,
                        color: ColorConstants.kwhiteColor,
                      ),
                    ],
                  ),
                ],
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  child: LineChart(
                    LineChartData(
                      minX: 1,
                      maxX: 30,
                      minY: 0,
                      maxY: 320,
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              const labels = {
                                1: '1',
                                5: '5',
                                10: '10',
                                15: '15',
                                20: '20',
                                25: '25',
                                30: '30',
                              };
                              final intVal = value.toInt();
                              if (labels.containsKey(intVal)) {
                                return Text(
                                  labels[intVal]!,
                                  style: TextStyle(
                                    color: ColorConstants.kwhiteColor,
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(1, 100),
                            FlSpot(5, 130),
                            FlSpot(10, 300),
                            FlSpot(15, 150),
                            FlSpot(20, 75),
                            FlSpot(25, 100),
                            FlSpot(30, 250),
                          ],
                          isCurved: true,
                          color: ColorConstants.korangeColor,
                          barWidth: 3,
                          dotData: FlDotData(
                            show: true,
                            //dotSize: 4,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                  radius: 4,
                                  color: ColorConstants.korangeColor,
                                  strokeColor: ColorConstants.kwhiteColor,
                                ),
                          ),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      borderData: FlBorderData(show: false),
                      backgroundColor: ColorConstants.kblackColor,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 3.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: ColorConstants.korangeColor,
                    ),
                    child: Center(
                      child: Text(
                        "Apr to Jun",
                        /*style: GoogleFonts.spartan(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.kwhiteColor,
                        ),*/
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GraphCardWidget(
                    title: Constants.strList[0],
                    activeColor: color,
                    fontColor: fcolor,
                    isActive: isActive,
                  ),
                  SizedBox(width: 10),
                  GraphCardWidget(
                    title: Constants.strList[1],
                    activeColor: color,
                    fontColor: fcolor,
                    isActive: isActive,
                  ),
                  SizedBox(width: 10),
                  GraphCardWidget(
                    title: Constants.strList[2],
                    activeColor: color,
                    fontColor: fcolor,
                    isActive: isActive,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Income",
                    /*style: GoogleFonts.spartan(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.kgreyColor,
                    ),*/
                  ),
                  Row(
                    children: [
                      Text(
                        "75%",
                        /*style: GoogleFonts.spartan(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.kgreyColor,
                        ),*/
                      ),
                      Icon(
                        Icons.arrow_downward,
                        color: ColorConstants.kwhiteColor,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Outcome",
                    /*style: GoogleFonts.spartan(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.kgreyColor,
                    ),*/
                  ),
                  Row(
                    children: [
                      Text(
                        "25%",
                        /*style: GoogleFonts.spartan(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.kgreyColor,
                        ),*/
                      ),
                      Icon(
                        Icons.arrow_upward,
                        color: ColorConstants.kwhiteColor,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
