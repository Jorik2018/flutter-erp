import 'dart:convert';
import 'dart:math';

import '../models/models.dart';
import '../Util/SharedPreferencesHelper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

var isLoading = false;
List<LinearSales> chartList = [];

class CoinDescription extends StatefulWidget {
  GetCoinsAdd coinsAdd;
  final random = Random();

  CoinDescription(this.coinsAdd);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return coindes(coinsAdd);
  }
}

class coindes extends State<CoinDescription> {
  final Dio _dio = Dio();
  GetCoinsAdd coinsAdd;
  String map = "1D";
  String chartReport = "histoday";

  // var data = _generateRandomData(50);
  coindes(this.coinsAdd);

  bool press_1M = false;
  bool press_1H = false;
  bool press_1D = false;

  String txt_press_1M = "1M";
  String txt_press_1H = "1H";
  String txt_press_1D = "1D";
  double LowPrice = 0.0;
  double HighPrice = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchCurrencies();
  }

  Future fetchCurrencies() async {
    setState(() {
      isLoading = true;
    });
    String curenncy = await SharedPreferencesHelper.getCurrency();
    // TODO: implement fetchCurrencies

    final response = await _dio.get<dynamic>(
      'https://min-api.cryptocompare.com/data/$chartReport',
      queryParameters: {'fsym': coinsAdd.coinInfo.name, 'tsym': curenncy},
    );

    if (response.statusCode != 200 || response.data is! Map) {
      throw Exception(
        'Error al consultar CryptoCompare. '
        'Código HTTP: ${response.statusCode}',
      );
    }

    final responseBody = Map<String, dynamic>.from(response.data as Map);

    var priceData = responseBody['Data'];
    List data = responseBody['Data'];

    var lowvalue = [];
    List highalue = [];
    for (int i = 0; i < data.length; i++) {
      lowvalue.add(data[i]['low']);
      highalue.add(data[i]['high']);
    }

    final statusCode = response.statusCode;
    if (statusCode != 200 || responseBody == null) {
      throw Exception("An error ocurred : [Status Code : $statusCode]");
    }

    chartList = (data).map((data) => LinearSales.fromMap(data)).toList();
    setState(() {
      LowPrice = (lowvalue.reduce((curr, next) => curr < next ? curr : next));
      HighPrice = (highalue.reduce((curr, next) => curr > next ? curr : next));
      isLoading = false;
      chartList = chartList;
    });
    return data.map((c) => LinearSales.fromMap(c)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            coinsAdd.coinInfo.fullName,
            style: TextStyle(fontSize: 20.0),
          ),
          elevation: 0.0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Image.network(
                "https://www.cryptocompare.com" + coinsAdd.coinInfo.imageUrl,
                height: 40,
                width: 40,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 15.0),
                    child: Text(
                      coinsAdd.display.usd.price,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, right: 15.0),
                    child: Text(
                      (double.parse(coinsAdd.display.usd.changePct24Hour) ??
                                  0) >=
                              0
                          ? "+" +
                                (double.parse(
                                          coinsAdd.display.usd.changePct24Hour,
                                        ) ??
                                        0)
                                    .toStringAsFixed(2) +
                                "%"
                          : (double.parse(
                                          coinsAdd.display.usd.changePct24Hour,
                                        ) ??
                                        0)
                                    .toStringAsFixed(2) +
                                "%",
                      style: Theme.of(context).primaryTextTheme.bodyMedium!
                          .apply(
                            color:
                                (double.parse(
                                          coinsAdd.display.usd.changePct24Hour,
                                        ) ??
                                        0) >=
                                    0
                                ? Colors.green
                                : Colors.red,
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      //child: Text(coinsAdd.Display.USD.MARKET),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      //child: Text(coinsAdd.Display.USD.MARKET),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    child: Text(
                      "LOW : \$" + LowPrice.toString(),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    child: Text(
                      "HIGH : \$" + HighPrice.toString(),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(map),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 330.0,
                child: AreaAndLineChart.withRandomData(),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            map = "1M";
                            chartReport = "histominute";
                            fetchCurrencies();
                          });
                        },
                        child: Text(
                          "1M",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            map = "1H";
                            chartReport = "histohour";
                            fetchCurrencies();
                          });
                        },
                        child: Text(
                          "1H",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            map = "1D";
                            chartReport = "histoday";
                            fetchCurrencies();
                          });
                        },
                        child: Text(
                          "1D",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "VOLUME(1D)",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            coinsAdd.display.usd.volume24HourTo,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "MARKET CAP",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            coinsAdd.display.usd.mktCap,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "RANK",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "1",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "CIRCULATING SUPPLY",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            coinsAdd.display.usd.supply,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}

class VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      width: 1.0,
      color: Colors.black,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }
}

class AreaAndLineChart extends StatelessWidget {
  final List<LinearSales> data;
  final bool isLoading;

  const AreaAndLineChart({
    super.key,
    required this.data,
    this.isLoading = false,
  });

  factory AreaAndLineChart.withRandomData() {
    return AreaAndLineChart(data: _createRandomData());
  }

  static List<LinearSales> _createRandomData() {
    return chartList;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data.isEmpty) {
      return const Center(child: Text('No hay datos para mostrar'));
    }

    final spots =
        data.map((sale) => FlSpot(sale.time.toDouble(), sale.close)).toList()
          ..sort((a, b) => a.x.compareTo(b.x));

    return LineChart(
      LineChartData(
        minX: spots.first.x,
        maxX: spots.last.x,
        minY: 0,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: _horizontalInterval(spots),
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.withOpacity(0.25), strokeWidth: 1),
          getDrawingVerticalLine: (value) =>
              FlLine(color: Colors.grey.withOpacity(0.15), strokeWidth: 1),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: Colors.grey.shade400),
            bottom: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              interval: _horizontalInterval(spots),
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 11),
                  textAlign: TextAlign.right,
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: _xInterval(spots),
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 11),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  'Tiempo: ${spot.x.toInt()}\n'
                  'Valor: ${spot.y.toStringAsFixed(2)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withAlpha(0),
            ),
          ),
        ],
      ),
    );
  }

  double _horizontalInterval(List<FlSpot> spots) {
    final min = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    final max = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    final range = max - min;

    return range > 0 ? range / 4 : 1;
  }

  double _xInterval(List<FlSpot> spots) {
    final range = spots.last.x - spots.first.x;

    return range > 0 ? range / 4 : 1;
  }
}

class LinearSales {
  final int time;
  final double close;

  LinearSales(this.time, this.close);

  LinearSales.fromMap(Map<String, dynamic> map)
    : time = (map['time'] as num?)?.toInt() ?? 0,
      close =
          (map['close'] as num?)?.toDouble() ??
          double.tryParse(map['close']?.toString() ?? '') ??
          0.0;
}
