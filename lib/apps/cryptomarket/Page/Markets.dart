import 'dart:convert';

import '../Model/models.dart';
import 'CoinDescription.dart';
import 'Dashboard.dart';
import 'MarketCoins.dart';
import '../Util/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';
import '../Model/GetCoinsAdd.dart';

import '../bloc/bloc.dart';
import '../flutter_bloc.dart';
import 'package:http/http.dart' as http;

class Markets_Screen extends StatefulWidget {
  const Markets_Screen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return markets();
  }
}

class markets extends State<Markets_Screen> {
  final _scrollController = ScrollController();

  //final PostBloc _postBloc = PostBloc(httpClient: http.Client());
  final _scrollThreshold = 200.0;
  TextEditingController controller = TextEditingController();
  List<GetCoinsAdd> search_coin_list = [];

  List<GetCoinsAdd> coinList = [];
  var isLoading = false;
  bool _value = false;

  List _selecteCategorys = [];

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Markets'), centerTitle: true),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CoinDescription(search_coin_list[index]),
                            ),
                          );
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CoinDescription(coinList[index]),
                            ),
                          );
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
                              builder: (context) => Brand_SearchList()));
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
                                  title: Text(state.posts[index].CoinInfo.FullName),
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
    setState(() {
      isLoading = true;
    });
    // TODO: implement fetchCurrencies
    String currency = await SharedPreferencesHelper.getCurrency();
    List coins = await SharedPreferencesHelper.getCoinList();
    /*  String coinsdata = coins.toString().replaceAll('[', '').replaceAll(']', '');
    String Baseurl = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=" + coinsdata + "&tsyms=" + currency + "&extraParams=your_app_name";
*/
    String apiUrl =
        'https://min-api.cryptocompare.com/data/top/mktcapfull?limit=100&tsym=' +
        currency;

    // Make a HTTP GET request to the CoinMarketCap API.
    // Await basically pauses execution until the get() function returns a Response
    http.Response response = await http.get(Uri.parse(apiUrl));
    var responseBody = json.decode(response.body);
    List data = responseBody['Data'];

    final statusCode = response.statusCode;
    if (statusCode != 200 || responseBody == null) {
      throw Exception("An error ocurred : [Status Code : $statusCode]");
    }

    coinList = (data).map((data) => GetCoinsAdd.fromMap(data)).toList();
    setState(() {
      isLoading = false;
    });
    return data.map((c) => GetCoinsAdd.fromMap(c)).toList();
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
