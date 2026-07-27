import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/models.dart';
import '../Util/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';

var isLoading = false;
List<LinearSales> chartList = [];

class MarketCoinDescription extends StatefulWidget {
  CoinsMarketData coinsMarketData;
  final random = Random();

  MarketCoinDescription(this.coinsMarketData);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return marketcoindes(coinsMarketData);
  }
}

class marketcoindes extends State<MarketCoinDescription> {
  CoinsMarketData coinsMarketData;
  String map = "1D";
  String chartReport = "histoday";
  final Dio _dio = Dio();

  // var data = _generateRandomData(50);
  marketcoindes(this.coinsMarketData);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCurrencies();
  }

  Future<List<LinearSales>> fetchCurrencies() async {
    setState(() => isLoading = true);

    try {
      final currency = await SharedPreferencesHelper.getCurrency();

      final response = await _dio.get<dynamic>(
        'https://min-api.cryptocompare.com/data/$chartReport',
        queryParameters: {'fsym': coinsMarketData.FROMSYMBOL, 'tsym': currency},
      );

      if (response.statusCode != 200 || response.data is! Map) {
        throw Exception(
          'Error al consultar CryptoCompare. '
          'Código HTTP: ${response.statusCode}',
        );
      }

      final responseBody = Map<String, dynamic>.from(response.data as Map);
      final responseData = responseBody['Data'];

      if (responseData is! List) {
        throw Exception(
          responseBody['Message']?.toString() ??
              'No hay datos disponibles para la gráfica.',
        );
      }

      final charts = responseData
          .whereType<Map>()
          .map((item) => LinearSales.fromMap(Map<String, dynamic>.from(item)))
          .toList();

      if (mounted) {
        setState(() => chartList = charts);
      }

      return charts;
    } on DioException catch (error) {
      throw Exception(
        'Error de red: ${error.response?.statusCode ?? error.message}',
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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
            coinsMarketData.FROMSYMBOL,
            style: TextStyle(fontSize: 20.0),
          ),
          elevation: 0.0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Image.network(
                "https://www.cryptocompare.com" + coinsMarketData.ImageUrl,
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
                      coinsMarketData.PRICE,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, right: 15.0),
                    child: Text(
                      (double.parse(coinsMarketData.CHANGEPCT24HOUR) ?? 0) >= 0
                          ? "+" +
                                (double.parse(
                                          coinsMarketData.CHANGEPCT24HOUR,
                                        ) ??
                                        0)
                                    .toStringAsFixed(2) +
                                "%"
                          : (double.parse(coinsMarketData.CHANGEPCT24HOUR) ?? 0)
                                    .toStringAsFixed(2) +
                                "%",
                      style: Theme.of(context).primaryTextTheme.bodyMedium!
                          .apply(
                            color:
                                (double.parse(
                                          coinsMarketData.CHANGEPCT24HOUR,
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
                      child: Text(coinsMarketData.MARKET),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(coinsMarketData.MARKET),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    child: Text(
                      "LOW :" + coinsMarketData.LOW24HOUR,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    child: Text(
                      "HIGH :" + coinsMarketData.HIGH24HOUR,
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
                height: 250.0,
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
                            coinsMarketData.VOLUME24HOURTO,
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
                            coinsMarketData.MKTCAP,
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
                            coinsMarketData.SUPPLY,
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

class ChartVerticalDivider extends StatelessWidget {
  const ChartVerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 1,
      color: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}

class AreaAndLineChart extends StatelessWidget {
  final List<LinearSales> data;
  final bool animate;
  final bool isLoading;

  const AreaAndLineChart(
    this.data, {
    super.key,
    this.animate = false,
    this.isLoading = false,
  });

  factory AreaAndLineChart.withRandomData() {
    return AreaAndLineChart(_createRandomData());
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
      return const Center(child: Text('No hay datos disponibles'));
    }

    final spots =
        data.map((sales) => FlSpot(sales.time.toDouble(), sales.close)).toList()
          ..sort((a, b) => a.x.compareTo(b.x));

    final minX = spots.first.x;
    final maxX = spots.last.x;

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: 0,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.25), strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.15), strokeWidth: 1);
          },
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
              reservedSize: 45,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value < minX || value > maxX) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
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
              color: Colors.blue.withOpacity(0.20),
            ),
          ),
        ],
      ),
      duration: animate ? const Duration(milliseconds: 300) : Duration.zero,
    );
  }
}

class LinearSales {
  final int time;
  final double close;

  LinearSales(this.time, this.close);

  LinearSales.fromMap(Map<String, dynamic> map)
    : time = (map['time'] as num?)?.toInt() ?? 0,
      close = double.tryParse(map['close']?.toString() ?? '') ?? 0.0;
}
