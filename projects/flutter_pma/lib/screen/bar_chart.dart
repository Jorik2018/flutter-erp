import 'dart:async';
import 'dart:math';

import 'package:flutter_pma/utils/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BarChartSample1 extends StatefulWidget {
  const BarChartSample1({super.key});

  List<Color> get availableColors => const <Color>[
        Colors.purpleAccent,
        Colors.yellow,
        Colors.lightBlue,
        Colors.orange,
        Colors.pink,
        Colors.redAccent,
        Colors.green,
        Colors.blue,
        Colors.lightGreen,
        Colors.teal
      ];

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });
  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
     this.isSquare=true,
    this.size = 16,
    this.textColor = Colors.black,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

class BarChartSample1State extends State<BarChartSample1> {
  int touchedIndex = -1;

  bool isPlaying = false;

  List title = ["ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO"];
  List data = [
    [10, 20, 8],
    [78, 100, 4],
    [80, 87, 66],
    [8, 70, 89],
    [7, 78, 4],
    [78, 12, 1],
    [10, 20, 8],
    [70, 15, 5]
  ];

  Widget VBarChart(
      {required double width,
      dynamic? title,
      double padding = 0,
      double aspectRatio = 1,
      dynamic data}) {
    List<BarChartGroupData> barGroup = [];
    int cols = 0;
    List datasets = data['datasets'];
    int max = 0;
    List<Widget> legend=[];
    
    for (int i = 0; i < datasets.length; i++) {
      legend.add(Indicator(
        color: widget.availableColors[i],
        text: datasets[i]['label'].toString() ,
        size: touchedIndex == 0 ? 18 : 16,
        textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
      ));
      List item = datasets[i]['data'] as List;
      if (item.length > max) max = item.length;
      cols += item.length;
    }
    width = width - padding * 2-(max-1)*20;
    for (int i = 0; i < max; i++) {
      List<BarChartRodData> bars = [];

      for (int j = 0; j < datasets.length; j++) {
        var item = datasets[j]['data'];
        //num v= as num;//.toDouble();
        bars.add(BarChartRodData(
            borderRadius: BorderRadius.all(Radius.zero),
            toY: item[i].toDouble(),
            color: widget.availableColors[j],
            width: (width / cols) - 2));
      }
      barGroup.add(BarChartGroupData(x: i, barRods: bars, barsSpace: 0));
    }
    Widget getTitles(double value, TitleMeta meta) {
      Widget text = Text(data['labels'][value.toInt()]); 
      return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
      );
    }
    
    BarChartData barChartData = BarChartData(
      groupsSpace: 20,
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            reservedSize: 30
          ),
        ),
      ),
      barGroups: barGroup,
      gridData: FlGridData(show: true),
    );

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if(title!=null)...[Padding(padding:const EdgeInsets.only(bottom: 10) ,child:Text(title.toString()))],
            if(legend.length>0)...[
              Padding(padding:const EdgeInsets.only(bottom: 10) ,child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:legend
              ))
            ],
            Expanded(
              child: BarChart(barChartData),
            )
          ],
        ),
      ),
    );
  }

  double width = 0;
  bool isScreenWide = false;
  @override
  Widget build(BuildContext context) {
    Widget Flex2(List<Widget> children) {
      if (isScreenWide) {
        return Row(
          children: children.map<Widget>((e) => Expanded(child: e)).toList(),
        );
      }
      return Flex(direction: Axis.vertical, children: children);
    }

    return OrientationBuilder(builder: (context, orientation) {
      width = MediaQuery.of(context).size.width;
      isScreenWide = width >= 500;
      width = isScreenWide ? width / 2 : width;
      return Column(children: [
        Expanded(
            child: SingleChildScrollView(
                child: Column(children: [
          Flex2([
            VBarChart(width: width,title:'Vntass', padding: 20, data: {
              'labels': ['ENE', 'FEB', 'MAR', 'ABR', 'MAY'],
              'datasets': [
                {
                  'label': 'M',
                  'data': [12, 67, 8, 9, 89]
                },
                {
                  'label': 'F',
                  'data': [6, 17, 88, 96, 39]
                }
              ]
            }),
            VBarChart(width: width, padding: 20, data: {
              'labels': ['L', 'M', 'M', 'J', 'V'],
              'datasets': [
                {
                  'label': 'AA',
                  'data': [45, 7, 58, 19, 9]
                },
                {
                  'label': 'BB',
                  'data': [16, 17, 88, 26, 99]
                },
                {
                  'label': 'CC',
                  'data': [56, 97, 8, 46, 59]
                }
              ]
            })
          ]),
          Flex2([
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Indicator(
                    color: const Color(0xff0293ee),
                    text: 'One',
                    isSquare: false,
                    size: touchedIndex == 0 ? 18 : 16,
                    textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
                  ),
                  Indicator(
                    color: const Color(0xfff8b250),
                    text: 'Two',
                    isSquare: false,
                    size: touchedIndex == 1 ? 18 : 16,
                    textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
                  ),
                  Indicator(
                    color: const Color(0xff845bef),
                    text: 'Three',
                    isSquare: false,
                    size: touchedIndex == 2 ? 18 : 16,
                    textColor: touchedIndex == 2 ? Colors.black : Colors.grey,
                  ),
                  Indicator(
                    color: const Color(0xff13d38e),
                    text: 'Four',
                    isSquare: false,
                    size: touchedIndex == 3 ? 18 : 16,
                    textColor: touchedIndex == 3 ? Colors.black : Colors.grey,
                  ),
                ],
              ),
              AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 0,
                      sections: showingSections(),
                    ),
                  ))
            ])
          ]),
        
        ])))
      ]);
    });
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> areas = [];
    double total = 0;
    for (int i = 0; i < data.length; i++) {
      total += data[i][0];
    }
    for (int i = 0; i < data.length; i++) {
      areas.add(PieChartSectionData(
        radius: (width / 2) - 1,
        color: widget.availableColors[i],
        value: total / data[i][0],
        title: title[i] + ' (' + (total / data[i][0]).toStringAsFixed(2) + '%)',
        badgeWidget: _Badge(
          'assets/ophthalmology-svgrepo-com.svg',
          size: 30.0,
          borderColor: const Color(0xff0293ee),
        ),
        badgePositionPercentageOffset: .98,
      ));
    }
    return areas;
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text = Text(
        ""); /*
        (value.toInt() < title.length) ? title[value.toInt()].toString() : '',
        style: style);*/

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}
