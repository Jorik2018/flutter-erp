import 'package:equatable/equatable.dart';

import 'package:flutter_erp/apps/flutter_taxi_app_3/models/payment_method.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/models/taxi.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/models/taxi_booking.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/models/taxi_driver.dart';

abstract class TaxiBookingState extends Equatable {
  const TaxiBookingState();

  @override
  List<Object?> get props => const [];
}

class TaxiBookingNotInitializedState extends TaxiBookingState {
  const TaxiBookingNotInitializedState();
}

class TaxiBookingNotSelectedState extends TaxiBookingState {
  final List<Taxi> taxisAvailable;

  const TaxiBookingNotSelectedState({required this.taxisAvailable});

  @override
  List<Object?> get props => [taxisAvailable];
}

class DetailsNotFilledState extends TaxiBookingState {
  final TaxiBooking? booking;

  const DetailsNotFilledState({this.booking});

  @override
  List<Object?> get props => [booking];
}

class TaxiNotSelectedState extends TaxiBookingState {
  final TaxiBooking? booking;

  const TaxiNotSelectedState({this.booking});

  @override
  List<Object?> get props => [booking];
}

class PaymentNotInitializedState extends TaxiBookingState {
  final TaxiBooking? booking;
  final List<PaymentMethod> methodsAvailable;

  const PaymentNotInitializedState({
    this.booking,
    required this.methodsAvailable,
  });

  @override
  List<Object?> get props => [booking, methodsAvailable];
}

class TaxiNotConfirmedState extends TaxiBookingState {
  final TaxiDriver driver;
  final TaxiBooking booking;

  const TaxiNotConfirmedState({required this.driver, required this.booking});

  @override
  List<Object?> get props => [driver, booking];
}

class TaxiConfirmedState extends TaxiBookingState {
  final TaxiDriver driver;
  final TaxiBooking booking;

  const TaxiConfirmedState({required this.driver, required this.booking});

  @override
  List<Object?> get props => [driver, booking];
}

class TaxiBookingCancelledState extends TaxiBookingState {
  const TaxiBookingCancelledState();
}

class TaxiBookingLoadingState extends TaxiBookingState {
  final TaxiBookingState state;

  const TaxiBookingLoadingState({required this.state});

  @override
  List<Object?> get props => [state];
}

class TaxiBookingConfirmedState extends TaxiBookingState {
  final TaxiDriver driver;
  final TaxiBooking booking;

  const TaxiBookingConfirmedState({
    required this.driver,
    required this.booking,
  });

  @override
  List<Object?> get props => [driver, booking];
}
