import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_erp/apps/geoflutterfire/src/point.dart';
import 'package:flutter_erp/apps/geoflutterfire/src/collection.dart';

class Geoflutterfire {
  Geoflutterfire();

  GeoFireCollectionRef collection({required CollectionReference collectionRef}) {
    return GeoFireCollectionRef(collectionRef);
  }

  GeoFirePoint point({required double latitude, required double longitude}) {
    return GeoFirePoint(latitude, longitude);
  }
}
