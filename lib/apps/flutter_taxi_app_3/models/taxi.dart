import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_erp/apps/flutter_taxi_app_3/models/taxi_type.dart';

class Taxi extends Equatable {
  final String id;
  final String title;
  final bool? isAvailable;
  final String? plateNo;
  final TaxiType? taxiType;
  final LatLng? position;

  const Taxi(
    this.id,
    this.title,
    this.isAvailable,
    this.plateNo,
    this.taxiType,
    this.position,
  );

  const Taxi.named({
    required this.id,
    required this.title,
    this.isAvailable,
    this.plateNo,
    this.taxiType,
    this.position,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    isAvailable,
    plateNo,
    taxiType,
    position,
  ];
}
