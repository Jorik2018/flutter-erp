import 'CurrencyList_Screen.dart';
import 'ExchangeList_Screen.dart';
import 'Home.dart';
import 'NewsList_Screen.dart';
import 'Notification_Screen.dart';
import 'Theme_Screen.dart';
import '../Theme/MyThemes.dart';
import '../Theme/_CustomTheme.dart';
import '../Util/SharedPreferencesHelper.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return settings();
  }
}

class settings extends State<Settings> {
  String theme = "Light";
  String currency = "USD";
  String exchange = "Coinbase";
  String news = 'All';

  bool isSwitched = false;

  List newsList = [];

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {
    isSwitched = await SharedPreferencesHelper.getNotificationFlag();
    exchange = await SharedPreferencesHelper.getExchange();
    currency = await SharedPreferencesHelper.getCurrency();
    news = await SharedPreferencesHelper.getNews();
    setState(() {
      exchange = this.exchange;
      currency = this.currency;
      news = this.news;
      isSwitched = this.isSwitched;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Text('Settings', style: TextStyle(fontSize: 20.0)),
          elevation: 0.0,
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Theme'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Theme_Screen()),
                );
              },
            ),
            Divider(height: 10.0),
            ListTile(
              title: const Text('Currency'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CurrencyList_Screen(),
                  ),
                );
              },
            ),
            Divider(height: 10.0),
            ListTile(
              title: const Text('Exchange'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExchangeList_Screen(),
                  ),
                );
              },
            ),
            /*    ListTile(
              title: const Text('Exchange'),
              subtitle: Text(exchange),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                SimpleDialog dialog = SimpleDialog(
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () async {
                        //await SharedPreferencesHelper.s('Binance');
                        setState(() {
                          Navigator.of(context).pop();
                          exchange = "Binance";
                        });
                      },
                      child: Text('Binance'),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    SimpleDialogOption(
                      onPressed: () async {
                     //   await SharedPreferencesHelper.seCurrency('Bittrex');
                        setState(() {
                          Navigator.of(context).pop();
                          exchange = "Bittrex";
                        });
                      },
                      child: Text('Bittrex'),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    SimpleDialogOption(
                      onPressed: () async {
                     //   await SharedPreferencesHelper.seCurrency('Coinbase');
                        setState(() {
                          Navigator.of(context).pop();
                          exchange = "Coinbase";
                        });
                      },
                      child: Text('Coinbase'),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    SimpleDialogOption(
                      onPressed: () async {
                  //      await SharedPreferencesHelper.seCurrency('Kraken');
                        setState(() {
                          Navigator.of(context).pop();
                          exchange = "Kraken";
                        });
                      },
                      child: Text('Kraken'),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    SimpleDialogOption(
                      onPressed: () async {
                   //     await SharedPreferencesHelper.seCurrency('OKEx');
                        setState(() {
                          Navigator.of(context).pop();
                          exchange = "OKEx";
                        });
                      },
                      child: Text('OKEx'),
                    )
                  ],
                );

// Show dialog
                showDialog(context: context, child: dialog);
              },
            ),*/
            Divider(height: 10.0),
            ListTile(
              title: const Text('News'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsList_Screen()),
                );
              },
            ),
            /* ListTile(
              title: const Text('News'),
              subtitle: Text(news),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                SimpleDialog dialog = SimpleDialog(
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () async {
                        await SharedPreferencesHelper.seNews('coindesk');
                        setState(() {
                          Navigator.of(context).pop();
                          news = "coindesk";
                        });
                      },
                      child: const Text('Coindesk'),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    SimpleDialogOption(
                      onPressed: () async {
                        await SharedPreferencesHelper.seNews('cryptoslate');
                        setState(() {
                          Navigator.of(context).pop();
                          news = "cryptoslate";
                        });
                      },
                      child: const Text('Cryptoslate'),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    SimpleDialogOption(
                      onPressed: () async {
                        await SharedPreferencesHelper.seNews('ccn');
                        setState(() {
                          Navigator.of(context).pop();
                          news = "ccn";
                        });
                      },
                      child: const Text('Ccn'),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    SimpleDialogOption(
                      onPressed: () async {
                        await SharedPreferencesHelper.seNews('cryptobriefing');
                        setState(() {
                          Navigator.of(context).pop();
                          news = "cryptobriefing";
                        });
                      },
                      child: const Text('Cryptobriefing'),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    SimpleDialogOption(
                      onPressed: () async {
                        await SharedPreferencesHelper.seNews('cointelegraph');
                        setState(() {
                          Navigator.of(context).pop();
                          news = "cointelegraph";
                        });
                      },
                      child: const Text('Cointelegraph'),
                    ),
                  ],
                );
// Show dialog
                showDialog(context: context, child: dialog);
              },
            ),*/
            Divider(height: 10.0),
            ListTile(
              title: const Text('Push Notifications'),
              trailing: Switch(
                value: isSwitched,
                onChanged: (value) async {
                  if (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  } else {
                    await flutterLocalNotificationsPlugin.cancelAll();
                  }
                  await SharedPreferencesHelper.setNotificationFlag(value);

                  setState(() {
                    isSwitched = value;
                  });
                },
                activeTrackColor: Colors.green,
              ),
            ),
            Divider(height: 10.0),
            ListTile(title: const Text('Send Feedback')),
            Divider(height: 10.0),
            ListTile(title: const Text('Visit Website')),
            Divider(height: 10.0),
            ListTile(title: const Text('About Us')),
            Divider(height: 10.0),
          ],
        ),
      ),
    );
  }
}
