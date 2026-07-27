import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
//import 'package:geocoding/geocoding.dart';
import 'main.dart';
import 'package:flutter_erp/apps/taxiservice/helpers/date_time_format.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String? addressFromLocation;
  String? addressToLocation;
  final CollectionReference<Map<String, dynamic>> colOrdRef = FirebaseFirestore
      .instance
      .collection('orders');

  getPlaceFromLocation(double latitude, double longitude) async {
    addressFromLocation = '';
    /*var coordinates = Coordinates(latitude, longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(
      coordinates,
    );
    addressFromLocation = address.first.addressLine.toString();*/
    //print(address.first.addressLine.toString());
    //return addressFromLocation;
  }

  getPlaceToLocation(double latitude, double longitude) async {
    addressToLocation = '';
    /*var coordinates = Coordinates(latitude, longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(
      coordinates,
    );
    addressToLocation = address.first.addressLine.toString();*/
    //print(address.first.addressLine.toString());
    // return addressFromLocation;
  }

  @override
  void initState() {
    super.initState();
    // initConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    // print(clientDocRef);
    return Scaffold(
      appBar: AppBar(title: Text('История поездок')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: colOrdRef.snapshots(),
        builder: (context, snapshot) {
          if (!hasConnection) {
            return Center(
              child: Text(
                'Нет подключения к интернету',
                style: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            color: Colors.blueGrey[50],
            child: Stack(
              children: <Widget>[
                ListView.builder(
                  /**The property 'docs' can't be unconditionally accessed because the receiver can be 'null'.
Try making the access conditional (using '?.') or adding a null check to the target ('!'). */
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    if ('${ds['clientId']}' != null &&
                        '${ds['clientId']}' == clientDocRef) {
                      DateTime date = ds['date'];
                      String timeOfDay = ds['time'];
                      // getPlaceFromLocation(ds['fromLat'], ds['fromLong']);
                      // getPlaceToLocation(ds['toLat'], ds['toLong']);
                      return Card(
                        margin: EdgeInsets.all(15.0),

                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                leading: Text(
                                  'Откуда',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                title: Text(
                                  date.day.toString() +
                                      ' ' +
                                      convertMonth(date.month)! +
                                      ' ' +
                                      date.year.toString() +
                                      ' , в ' +
                                      timeOfDay,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                subtitle: Text(
                                  '${ds['fromAddress']}',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                              ListTile(
                                leading: Text(
                                  'Куда',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                title: Text(
                                  date.day.toString() +
                                      ' ' +
                                      convertMonth(date.month)! +
                                      ' ' +
                                      date.year.toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                subtitle: Text(
                                  '${ds['toAddress']}',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                'Тариф: ${ds['tarif']}',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                'Водитель: ',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                'Общая сумма: ',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return IgnorePointer(child: Container());
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
