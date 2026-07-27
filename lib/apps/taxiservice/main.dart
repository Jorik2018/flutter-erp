import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
//import 'package:map_view/map_view.dart';
import 'history_page.dart';
import 'info_page.dart';
import 'help_page.dart';
import 'settings_page.dart';
import 'login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'code_page.dart';
import 'settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_erp/apps/taxiservice/helpers/floating_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'order_page.dart';
import 'first_page.dart';
import 'package:geocoding/geocoding.dart';
import 'helpers/dialog_boxes.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_erp/apps/taxiservice/profile_page.dart';
import 'package:flutter_erp/apps/taxiservice/settings_page.dart';

var Api_key = '';
String? clientDocRef;

DocumentReference clientRef = FirebaseFirestore.instance
    .collection('data')
    .doc('$clientDocRef');

String? savedUserName;
String? savedPhoneNumber;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Taxi Service',
      home: StartApp(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => MainPage(),
        '/login': (BuildContext context) => StartApp(),
        '/code': (BuildContext context) => CodePage(),
        '/settings': (BuildContext context) => SettingsPage(),
        '/history': (BuildContext context) => History(),
        '/info': (BuildContext context) => Info(),
        '/help': (BuildContext context) => Help(),
        '/order': (BuildContext context) => OrderPage(),
        '/profile': (BuildContext context) => ProfilePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State createState() => MainPageState();
}

getClientId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  clientDocRef = pref.getString('userId');
  //clientDocRef = '-LFaqn6H-5a-Z9s058vE';
  print(clientDocRef);
}

class MainPageState extends State<MainPage> with TickerProviderStateMixin {
  static const LatLng _initialPosition = LatLng(41.311081, 69.240562);

  /// Mantiene el nombre mapView, pero cambia MapView por
  /// GoogleMapController.
  GoogleMapController? mapView;

  /// StaticMapProvider ya no existe.
  /// Conservamos el nombre para no romper referencias posteriores.
  final String provider = Api_key;

  late CameraPosition cameraPosition;

  /// Ya no necesitamos una URL de mapa estático para mostrar el mapa.
  Uri? urimap;

  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool hasConnection = false;

  double? latitude;
  double? longitude;
  double? fromLat;
  double? fromLong;

  final TextEditingController fromAddress = TextEditingController();

  LatLng currentMapPosition = _initialPosition;

  @override
  void initState() {
    super.initState();

    cameraPosition = CameraPosition(target: _initialPosition, zoom: 14);

    latitude = _initialPosition.latitude;
    longitude = _initialPosition.longitude;

    getUserInfo();
    getClientId();
    initConnectivity();
    _getMapTypeLocal();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );

    // Ya no usamos provider.getStaticUri().
    urimap = null;
  }

  Future<void> showMap() async {
    final GoogleMapController? controller = mapView;

    if (controller == null) {
      debugPrint('El mapa todavía no ha sido creado.');
      return;
    }

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentMapPosition, zoom: 14),
      ),
    );
  }

  Future<void> initConnectivity() async {
    try {
      final List<ConnectivityResult> result = await _connectivity
          .checkConnectivity();

      await _updateConnectionStatus(result);
    } on PlatformException catch (error) {
      debugPrint('Error comprobando conectividad: $error');
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    final bool connected =
        result.isNotEmpty && !result.contains(ConnectivityResult.none);

    if (!mounted) {
      return;
    }

    setState(() {
      hasConnection = connected;
    });
  }

  Future<void> onUserLocationUpdated(
    LatLng position,
    GoogleMapController mapview,
  ) async {
    final double zoomLevel = await mapview.getZoomLevel();

    /*await mapview.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoomLevel),
      ),
    );*/

    latitude = position.latitude;
    longitude = position.longitude;
    currentMapPosition = position;

    await getCurrentAddress();
  }

  Future<void> getCurrentAddress() async {
    final double? currentLatitude = latitude;
    final double? currentLongitude = longitude;

    if (currentLatitude == null || currentLongitude == null) {
      return;
    }

    debugPrint('Current location');

    try {
      final List<Placemark> address = await placemarkFromCoordinates(
        currentLatitude,
        currentLongitude,
      );

      if (address.isEmpty) {
        fromAddress.clear();
        return;
      }

      final Placemark place = address.first;

      final String addressLine =
          <String?>[
                place.street,
                place.subLocality,
                place.locality,
                place.administrativeArea,
                place.country,
              ]
              .whereType<String>()
              .where((String value) => value.trim().isNotEmpty)
              .join(', ');

      fromAddress.text = addressLine;
      fromLat = currentLatitude;
      fromLong = currentLongitude;

      debugPrint(addressLine);
    } catch (error, stackTrace) {
      debugPrint('Error obteniendo la dirección: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _getMapTypeLocal() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    final int mapType = pref.getInt('mapType') ?? 0;

    final MapType selectedMapType = mapType == 0
        ? MapType.normal
        : MapType.hybrid;

    if (!mounted) {
      return;
    }

    setState(() {
      staticmaptype = selectedMapType;
      mapViewType = selectedMapType;
    });
  }

  MapType? staticmaptype;
  MapType? mapViewType;
  getUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      savedUserName = pref.getString('userName')!;
      savedPhoneNumber = pref.getString('phoneNumber')!;
    });
  }

  Widget loadMap() {
    if (hasConnection) {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(child: CircularProgressIndicator()),
          InkWell(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: urimap.toString(),
              fit: BoxFit.cover,
            ),
            onTap: () {},
          ),
        ],
      );
    } else
      return Center(
        child: Text(
          'Нет подключения к сети',
          style: TextStyle(color: Colors.grey[400], fontSize: 18.0),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    getUserInfo();
    return Scaffold(
      backgroundColor: Colors.blue[20],
      bottomNavigationBar: Container(
        height: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.green[500]),
        child: Material(
          color: Colors.green,
          child: MaterialButton(
            minWidth: 350.0,
            height: 60.0,
            splashColor: Colors.green[600],
            child: Text(
              'Заказать',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            onPressed: () {
              if (hasConnection && (latitude != null && longitude != null)) {
                toAddress.clear();
                fromLat = latitude!;
                fromLong = longitude!;
                Navigator.pushNamed(context, '/order');
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => OrderPage()));
              } else {
                locationDialogBox(context);
              }
            },
          ),
        ),
      ),
      appBar: AppBar(title: Text('Taxi Service')),
      floatingActionButton: FabAnim(),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                '$savedUserName',
                style: TextStyle(fontSize: 20.0),
              ),
              accountEmail: Text('$savedPhoneNumber'),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/drawer_back.jpeg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            ListTileTheme(
              child: ListTile(
                title: Text('История поездок'),
                leading: Icon(Icons.timelapse),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/history');
                },
              ),
              // iconColor: Colors.brown,
              selectedColor: Colors.red,
            ),
            Divider(),
            ListTileTheme(
              child: ListTile(
                title: Text('Профиль'),
                leading: Icon(Icons.person),
                onTap: () {
                  Navigator.pop(context);
                  print(clientDocRef);
                  // Navigator.push(
                  //   context,
                  //MaterialPageRoute(
                  //  builder: (context) => ProfilePage()));
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              iconColor: Colors.blue[300],
              selectedColor: Colors.blueGrey,
            ),
            Divider(),
            ListTileTheme(
              child: ListTile(
                title: Text('Информация'),
                leading: Icon(Icons.info),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/info');
                },
              ),
              iconColor: Colors.indigo,
              selectedColor: Colors.indigo,
            ),
            Divider(),
            ListTileTheme(
              child: ListTile(
                title: Text('Настройки'),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              iconColor: Colors.blue[600],
              selectedColor: Colors.blue[600],
            ),
            Divider(),
            ListTileTheme(
              child: ListTile(
                title: Text('Служба поддержки'),
                leading: Icon(Icons.help),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/help');
                },
              ),
              iconColor: Colors.orange,
              selectedColor: Colors.orange,
            ),
          ],
        ),
      ),
      body: Container(height: 1000.0, child: loadMap()),
    );
  }
}
