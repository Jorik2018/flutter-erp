import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_erp/apps/taxiservice/helpers/floating_button.dart';
import 'code_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart'
    hide Location;
import 'places_search_page.dart';
import 'main.dart';
import 'package:flutter_erp/apps/taxiservice/helpers/dialog_boxes.dart';
import 'package:flutter_erp/apps/taxiservice/helpers/date_time_format.dart';

DocumentReference? orderRef;
final CollectionReference colRefOrders = FirebaseFirestore.instance.collection(
  "orders",
);
String? addressToField;
String? addressFromLocation;
String? addressFromQuery;
bool? fromfieldPressed;
double? fromLong;
double? fromLat;
double? toLong;
double? toLat;
Color locationIconColor = Colors.grey;
Color locationIconColor2 = Colors.grey;
final fromAddress = TextEditingController();
final toAddress = TextEditingController();
final GoogleApiConfig _placesConfig = GoogleApiConfig(
  apiKey: kGoogleApiKey,

  // Puedes restringir la búsqueda a Uzbekistán.
  //regionCode: 'UZ',

  // Descomenta para restringir resultados a un área.
  // locationRestriction: LocationConfig.circle(
  //   circleCenter: const Coordinates(
  //     latitude: 41.311081,
  //     longitude: 69.240562,
  //   ),
  //   circleRadiusInKilometers: 500,
  // ),
);

class OrderPage extends StatefulWidget {
  @override
  State createState() => OrderPageState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  final CollectionReference<Map<String, dynamic>> colRef = FirebaseFirestore
      .instance
      .collection('tariffs');

  final List<Widget> tablist2 = <Widget>[];
  Color TextButtonColor = Colors.transparent;

  FocusNode _focus1 = FocusNode();
  FocusNode _focus2 = FocusNode();
  var tariffName2 = "Эконом";
  var oneKmCost2 = '1200';
  var oneKmCost3;
  var availableCars2;
  var tarrifMin2;
  var waiting2;
  var carsDefault;
  var minDefault;
  var oneKmDefault;
  var waitingDefault;
  var tariffNameDefault;

  String? userId;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  //String tariff = "Эконом";

  Future<void> getPlaceFromQuery() async {
    const String query = '1600 Amphitheatre Parkway, Mountain View';

    try {
      final List<Location> address = await locationFromAddress(query);

      if (address.isEmpty) {
        addressFromQuery = null;
        return;
      }

      final Location location = address.first;

      addressFromQuery = query;

      fromLat = location.latitude;
      fromLong = location.longitude;

      debugPrint(
        'Resultado: $addressFromQuery '
        '(${location.latitude}, ${location.longitude})',
      );
    } catch (error, stackTrace) {
      debugPrint('Error buscando dirección: $error');

      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> openSearch() async {
    final Prediction? p = await _showGooglePlacesAutocomplete();

    if (!mounted || p == null) {
      return;
    }

    /*displayPrediction(
      p,
      homeScaffoldKey.currentState,
    );*/
  }

  Future<Prediction?> _showGooglePlacesAutocomplete() {
    final TextEditingController searchController = TextEditingController();

    return showModalBottomSheet<Prediction>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.viewInsetsOf(bottomSheetContext).bottom + 16,
          ),
          child: SizedBox(
            height: MediaQuery.sizeOf(bottomSheetContext).height * 0.85,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(bottomSheetContext);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Expanded(
                      child: Text(
                        'Buscar dirección',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GooglePlacesAutoCompleteTextFormField(
                  config: _placesConfig,
                  textEditingController: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Introduce una dirección',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  minInputLength: 3,
                  maxLines: 1,
                  onSuggestionClicked: (Prediction prediction) {
                    searchController.text = prediction.description ?? '';

                    Navigator.pop(bottomSheetContext, prediction);
                  },
                  onPredictionWithCoordinatesReceived: (Prediction prediction) {
                    debugPrint('Predicción: ${prediction.description}');

                    debugPrint(
                      'Coordenadas: '
                      '${prediction.lat}, ${prediction.lng}',
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(searchController.dispose);
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    print(clientDocRef);
    fromAddress.text = currentAddress!;
    setState(() {
      colorControllers();
      print(latitude.toString());
      print(longitude.toString());
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: _date,
      lastDate: _date.add(const Duration(days: 7)),
    );

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void getPressedField() {}

  void addOrder() {
    orderRef = colRefOrders.doc();
    orderRef!
        .set({
          'clientId': clientDocRef,
          'fromLat': fromLat,
          'fromLong': fromLong,
          'toLat': toLat,
          'toLong': toLong,
          'tarif': tariffName2,
          'date': _date,
          'time':
              _time.hour.toString() +
              ':' +
              convertMinute(_time.minute.toString()),
          // 'dateTime': DateTime.now(),
          'fromAddress': fromAddress.text,
          'toAddress': toAddress.text,
        })
        .whenComplete(() {
          print("Order is made");
          fromLat = null;
          fromLong = null;
          toLat = null;
          toLong = null;
        })
        .catchError((e) => print(e));
  }

  void colorControllers() {
    if (toAddress.text.isNotEmpty) {
      locationIconColor2 = Colors.blue;
    } else {
      locationIconColor2 = Colors.grey;
    }
    if (fromAddress.text.isNotEmpty) {
      locationIconColor = Colors.blue;
    } else {
      locationIconColor = Colors.grey;
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      // print('selected time $_date');
      setState(() {
        _time = picked;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    _focus1.dispose();
    _focus2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    colorControllers();
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали заказа'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            height: 60.0,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: colRef.snapshots(),
              builder:
                  (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
                  ) {
                    if (!hasConnection) {
                      return const Center(child: Text('Sin conexión'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error al cargar tarifas: ${snapshot.error}',
                        ),
                      );
                    }

                    final docs = snapshot.data?.docs ?? [];

                    if (docs.isEmpty) {
                      return const Center(
                        child: Text('No hay tarifas disponibles'),
                      );
                    }

                    final firstData = docs.first.data();

                    tariffNameDefault = firstData['name']?.toString();
                    oneKmDefault = firstData['one_km']?.toString();
                    minDefault = firstData['min']?.toString();
                    waitingDefault = firstData['waiting']?.toString();
                    carsDefault = firstData['cars']?.toString();

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final DocumentSnapshot<Map<String, dynamic>> ds =
                            docs[index];

                        final data = ds.data() ?? <String, dynamic>{};

                        final String tariffName =
                            data['name']?.toString() ?? '';

                        final String oneKmCost =
                            data['one_km']?.toString() ?? '0';

                        return Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 0.2, color: Colors.grey),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                tariffName2 = tariffName;

                                oneKmCost2 = oneKmCost.length >= 4
                                    ? oneKmCost.substring(0, 4)
                                    : oneKmCost;

                                oneKmCost3 = oneKmCost;
                                tarrifMin2 = data['min'];
                                availableCars2 = data['cars'];
                                waiting2 = data['waiting'];
                              });
                            },
                            child: Text(
                              tariffName,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        );
                      },
                    );
                  },
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(5.0),
          children: <Widget>[
            SizedBox(height: 30.0),
            ListTile(
              leading: Icon(Icons.location_on, color: locationIconColor),
              title: InkWell(
                child: TextField(
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: fromAddress,
                  autofocus: false,
                  decoration: InputDecoration(hintText: "Откуда"),
                  focusNode: _focus1,
                ),
                onTap: () {
                  fromfieldPressed = true;
                  openSearch();
                },
              ),
              trailing: InkWell(
                child: Icon(Icons.close),
                onTap: () {
                  // fromAddress.clear();
                  addressFromLocation = '';
                },
              ),
            ),
            SizedBox(height: 20.0),
            ListTile(
              leading: Icon(Icons.location_on, color: locationIconColor2),
              title: InkWell(
                child: TextField(
                  onChanged: (text) {
                    locationIconColor2 = Colors.blue;
                  },
                  enabled: false,
                  keyboardType: TextInputType.text,
                  controller: toAddress,
                  autofocus: false,
                  decoration: InputDecoration(hintText: 'Куда'),
                  focusNode: _focus2,
                ),
                onTap: () {
                  fromfieldPressed = false;
                  openSearch();
                },
              ),
              trailing: InkWell(
                child: Icon(Icons.close),
                onTap: () {
                  toAddress.clear();
                  addressToField = '';
                },
              ),
            ),
            SizedBox(height: 30.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(
                    horizontal: 50.0,
                    vertical: 5.0,
                  ),
                  child: Text(
                    'Тариф',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[500]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 40.0,
                  ),
                  child: Material(
                    child: InkWell(
                      child: Card(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 15.0,
                          ),
                          height: 120.0,
                          width: 250.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.directions_car),
                              SizedBox(height: 5.0),
                              Text(
                                tariffName2,
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                ' $oneKmCost2 сум за 1 км',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  30.0,
                                  20.0,
                                  30.0,
                                  10.0,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              tariffName2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 24.0),
                                            ),
                                          ),
                                          SizedBox(height: 20.0),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: Icon(Icons.donut_large),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  availableCars2 == null
                                                      ? carsDefault.toString()
                                                      : availableCars2,
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: Icon(Icons.donut_large),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  tarrifMin2 == null
                                                      ? minDefault.toString()
                                                      : tarrifMin2,
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: Icon(Icons.donut_large),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  oneKmCost3 == null
                                                      ? oneKmDefault.toString()
                                                      : oneKmCost3,
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: Icon(Icons.donut_large),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  waiting2 == null
                                                      ? waitingDefault
                                                            .toString()
                                                      : waiting2,
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          top: 30.0,
                                          bottom: 10.0,
                                        ),
                                        padding: EdgeInsets.fromLTRB(
                                          5.0,
                                          15.0,
                                          15.0,
                                          5.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                            5.0,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: MaterialButton(
                                          child: Text(
                                            'Закрыть',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.date_range, color: Colors.blue),
                  title: InkWell(
                    child: Text(
                      '${_date.day.toString()}' +
                          ' ' +
                          convertMonth(_date.month)!.toLowerCase() +
                          ' ' +
                          _date.year.toString(),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  trailing: InkWell(
                    child: Icon(Icons.edit),
                    onTap: () => _selectDate(context),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.access_time, color: Colors.blue),
                  title: InkWell(
                    child: Text(
                      _time.hour.toString() +
                          ':' +
                          convertMinute(_time.minute.toString()),
                    ),
                    onTap: () {
                      setState(() {
                        _selectTime(context);
                      });
                    },
                  ),
                  trailing: InkWell(
                    child: Icon(Icons.edit),
                    onTap: () {
                      setState(() {
                        _selectTime(context);
                      });
                    },
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.green,
        ),
        height: 70.0,
        child: Material(
          color: Colors.green,
          child: MaterialButton(
            splashColor: Colors.green[600],
            height: 50.0,
            minWidth: 320.0,
            child: Text(
              'Вызвать такси',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            onPressed: () {
              orderDialogBox(context);
              addOrder();
            },
          ),
        ),
      ),
    );
  }
}
