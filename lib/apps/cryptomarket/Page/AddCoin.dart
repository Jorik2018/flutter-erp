import 'dart:convert';

import 'package:flutter_erp/apps/cryptomarket/models/GetCoinsAdd.dart';

import 'Dashboard.dart';
import '../Util/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AddCoin extends StatefulWidget {
  const AddCoin({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return addCoin();
  }
}

class addCoin extends State<AddCoin> {
  final Dio dio = Dio();
  TextEditingController controller = TextEditingController();
  List<GetCoinsAdd> search_coin_list = [];

  List<GetCoinsAdd> coinList = [];
  var isLoading = false;
  bool _value = false;

  List _selecteCategorys = [];

  void _onCategorySelected(selected, category_id) {
    if (selected == true) {
      if (_selecteCategorys.contains(category_id)) {
      } else {
        setState(() {
          _selecteCategorys.add(category_id);
        });
      }
    } else {
      setState(() {
        _selecteCategorys.remove(category_id);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoin();
  }

  getCoin() async {
    _selecteCategorys = await SharedPreferencesHelper.getCoinList();
    fetchCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Add Coin'), centerTitle: true),
      bottomNavigationBar: GestureDetector(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          height: 50.0,
          color: Colors.black,
          child: Center(
            child: Text(
              'Apply',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onTap: () async {
          await SharedPreferencesHelper.setCoinsList(
            _selecteCategorys.toList() as List<String>,
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
            (Route<dynamic> route) => false,
          );
        },
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Search Coins',
                      border: InputBorder.none,
                    ),
                    onChanged: onSearchTextChanged,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: search_coin_list.length != 0 || controller.text.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: search_coin_list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _value = _selecteCategorys.contains(
                              search_coin_list[index].coinInfo.name,
                            );
                            _value = !_value;
                            _onCategorySelected(
                              _value,
                              search_coin_list[index].coinInfo.name,
                            );
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  top: 5.0,
                                  right: 10.0,
                                  bottom: 5.0,
                                ),
                                child: Image.network(
                                  "https://www.cryptocompare.com" +
                                      search_coin_list[index].coinInfo.imageUrl,
                                  height: 50.0,
                                  width: 50.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  top: 5.0,
                                  right: 10.0,
                                  bottom: 5.0,
                                ),
                                child: Text(
                                  search_coin_list[index].coinInfo.fullName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    top: 10.0,
                                    right: 20.0,
                                    bottom: 10.0,
                                  ),
                                  child:
                                      _selecteCategorys.contains(
                                        search_coin_list[index].coinInfo.name,
                                      )
                                      ? Icon(Icons.check, size: 30.0)
                                      : Container(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: coinList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _value = _selecteCategorys.contains(
                              coinList[index].coinInfo.name,
                            );
                            _value = !_value;
                            _onCategorySelected(
                              _value,
                              coinList[index].coinInfo.name,
                            );
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  top: 5.0,
                                  right: 10.0,
                                  bottom: 5.0,
                                ),
                                child: Image.network(
                                  "https://www.cryptocompare.com" +
                                      coinList[index].coinInfo.imageUrl,
                                  height: 50.0,
                                  width: 50.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  top: 5.0,
                                  right: 10.0,
                                  bottom: 5.0,
                                ),
                                child: Text(
                                  coinList[index].coinInfo.fullName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    top: 10.0,
                                    right: 20.0,
                                    bottom: 10.0,
                                  ),
                                  child:
                                      _selecteCategorys.contains(
                                        coinList[index].coinInfo.name,
                                      )
                                      ? Icon(Icons.check, size: 30.0)
                                      : Container(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      /* Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: 'Search product', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                */
      /*  trailing: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Brand_Search[]));
                    },
                  ),*/
      /*
                ),
              ),
            ),
          ),

          Container(
              margin: EdgeInsets.only(top: 5.0),
              child: BlocBuilder(
                bloc: _postBloc,
                builder: (BuildContext context, PostState state) {
                  if (state is PostUninitialized) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is PostError) {
                    return Center(
                      child: Text('failed to fetch posts'),
                    );
                  }
                  if(state is PostLoaded){
                    return onSearchTextChanged(controller.text);
                  }
                  if (state is PostLoaded) {
                    if (state.posts.isEmpty) {
                      return Center(
                        child: Text('no posts'),
                      );
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                      itemCount: state.posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return   Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Image.network(
                                "https://www.cryptocompare.com" + state.posts[index].CoinInfo.ImageUrl,
                                height: 50.0,
                                width: 50.0,
                              ),
                            ),
                            Expanded(
                                flex: 8,
                                child: CheckboxListTile(
                                  value: _selecteCategorys.contains(state.posts[index].CoinInfo.name),
                                  onChanged: (bool selected) {
                                    _onCategorySelected(selected,
                                        state.posts[index].CoinInfo.name);
                                  },
                                  title: Text(state.posts[index].coinInfo.fullName),
                                )
                            ),
                          ],
                        );
                      },

                    );
                  }
                },
              )),
        ],
      )*/
    );
  }

  Widget _serarch() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ListTile(
            leading: Icon(Icons.search),
            title: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search product',
                border: InputBorder.none,
              ),
              onChanged: onSearchTextChanged,
            ),
          ),
        ),
      ),
    );
  }

  Future<List<GetCoinsAdd>> fetchCurrencies() async {
    setState(() => isLoading = true);

    try {
      final currency = await SharedPreferencesHelper.getCurrency();

      final response = await dio.get<dynamic>(
        'https://min-api.cryptocompare.com/data/top/mktcapfull',
        queryParameters: {'limit': 100, 'tsym': currency},
      );

      if (response.statusCode != 200 || response.data is! Map) {
        throw Exception(
          'Error al consultar CryptoCompare. '
          'Código HTTP: ${response.statusCode}',
        );
      }

      final responseBody = Map<String, dynamic>.from(response.data as Map);
      final data = responseBody['Data'];

      if (data is! List) {
        throw Exception(
          responseBody['Message']?.toString() ??
              'No se encontraron criptomonedas.',
        );
      }

      final coins = data
          .whereType<Map>()
          .map((coin) => GetCoinsAdd.fromMap(Map<String, dynamic>.from(coin)))
          .toList();

      setState(() => coinList = coins);

      return coins;
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

  onSearchTextChanged(String text) async {
    search_coin_list.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    coinList.forEach((userDetail) {
      if (userDetail.coinInfo.fullName.toLowerCase().contains(
            text.toLowerCase(),
          ) ||
          userDetail.coinInfo.fullName.toLowerCase().contains(
            text.toLowerCase(),
          ))
        search_coin_list.add(userDetail);
    });

    setState(() {});
  }
}
