import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_erp/apps/flutter_taxi_app_3/models/google_location.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/models/payment_method.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/models/taxi_type.dart';

abstract class TaxiBookingEvent extends Equatable {
  const TaxiBookingEvent();

  @override
  List<Object?> get props => const [];
}

class TaxiBookingStartEvent extends TaxiBookingEvent {
  const TaxiBookingStartEvent();
}

class DestinationSelectedEvent extends TaxiBookingEvent {
  final LatLng? destination;

  const DestinationSelectedEvent({this.destination});

  @override
  List<Object?> get props => [destination];
}

class DetailsSubmittedEvent extends TaxiBookingEvent {
  final GoogleLocation source;
  final GoogleLocation destination;
  final int noOfPersons;
  final DateTime bookingTime;

  const DetailsSubmittedEvent({
    required this.source,
    required this.destination,
    required this.noOfPersons,
    required this.bookingTime,
  });

  @override
  List<Object?> get props => [source, destination, noOfPersons, bookingTime];
}

class TaxiSelectedEvent extends TaxiBookingEvent {
  final TaxiType taxiType;

  const TaxiSelectedEvent({required this.taxiType});

  @override
  List<Object?> get props => [taxiType];
}

class PaymentMadeEvent extends TaxiBookingEvent {
  final PaymentMethod? paymentMethod;

  const PaymentMadeEvent({this.paymentMethod});

  @override
  List<Object?> get props => [paymentMethod];
}

class BackPressedEvent extends TaxiBookingEvent {
  const BackPressedEvent();
}

class TaxiBookingCancelEvent extends TaxiBookingEvent {
  const TaxiBookingCancelEvent();
}
