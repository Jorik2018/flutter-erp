import 'package:flutter_erp/apps/flutter_taxi_app_3/models/taxi_booking.dart';

class TaxiBookingStorage {
  static late TaxiBooking _taxiBooking;

  static Future<void> open() async {
    _taxiBooking = const TaxiBooking.named();
  }

  static Future<TaxiBooking> addDetails(TaxiBooking taxiBooking) async {
    _taxiBooking = _taxiBooking.copyWith(taxiBooking);
    return _taxiBooking;
  }

  static Future<TaxiBooking> getTaxiBooking() async {
    return _taxiBooking;
  }
}
