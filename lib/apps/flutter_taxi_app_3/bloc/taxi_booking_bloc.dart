import 'package:bloc/bloc.dart';

import 'package:flutter_erp/apps/flutter_taxi_app_3/bloc/taxi_booking_event.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/bloc/taxi_booking_state.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/controllers/location_controller.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/controllers/payment_method_controller.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/controllers/taxi_booking_controller.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/models/google_location.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/models/payment_method.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/models/taxi.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/models/taxi_booking.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/models/taxi_driver.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/storage/taxi_booking_storage.dart';

class TaxiBookingBloc extends Bloc<TaxiBookingEvent, TaxiBookingState> {
  TaxiBookingBloc() : super(const TaxiBookingNotInitializedState()) {
    on<TaxiBookingStartEvent>(_onStart);
    on<DestinationSelectedEvent>(_onDestinationSelected);
    on<DetailsSubmittedEvent>(_onDetailsSubmitted);
    on<TaxiSelectedEvent>(_onTaxiSelected);
    on<PaymentMadeEvent>(_onPaymentMade);
    on<TaxiBookingCancelEvent>(_onCancel);
    on<BackPressedEvent>(_onBackPressed);
  }

  Future<void> _onStart(
    TaxiBookingStartEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    final List<Taxi> taxis = await TaxiBookingController.getTaxisAvailable();

    emit(TaxiBookingNotSelectedState(taxisAvailable: taxis));
  }

  Future<void> _onDestinationSelected(
    DestinationSelectedEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    await TaxiBookingStorage.open();

    emit(TaxiBookingLoadingState(state: DetailsNotFilledState(booking: null)));

    final GoogleLocation source = await LocationController.getCurrentLocation();

    final GoogleLocation destination =
        await LocationController.getLocationfromId(event.destination!);

    await TaxiBookingStorage.addDetails(
      TaxiBooking.named(
        source: source,
        destination: destination,
        noOfPersons: 1,
      ),
    );

    final TaxiBooking booking = await TaxiBookingStorage.getTaxiBooking();

    emit(DetailsNotFilledState(booking: booking));
  }

  Future<void> _onDetailsSubmitted(
    DetailsSubmittedEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    emit(TaxiBookingLoadingState(state: TaxiNotSelectedState(booking: null)));

    await Future.delayed(const Duration(seconds: 1));

    await TaxiBookingStorage.addDetails(
      TaxiBooking.named(
        source: event.source,
        destination: event.destination,
        noOfPersons: event.noOfPersons,
        bookingTime: event.bookingTime,
      ),
    );

    final TaxiBooking booking = await TaxiBookingStorage.getTaxiBooking();

    emit(TaxiNotSelectedState(booking: booking));
  }

  Future<void> _onTaxiSelected(
    TaxiSelectedEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    emit(
      TaxiBookingLoadingState(
        state: PaymentNotInitializedState(
          booking: null,
          methodsAvailable: const [],
        ),
      ),
    );

    final TaxiBooking previousBooking =
        await TaxiBookingStorage.getTaxiBooking();

    final double price = await TaxiBookingController.getPrice(previousBooking);

    await TaxiBookingStorage.addDetails(
      TaxiBooking.named(taxiType: event.taxiType, estimatedPrice: price),
    );

    final TaxiBooking booking = await TaxiBookingStorage.getTaxiBooking();

    final List<PaymentMethod> methods =
        await PaymentMethodController.getMethods();

    emit(
      PaymentNotInitializedState(booking: booking, methodsAvailable: methods),
    );
  }

  Future<void> _onPaymentMade(
    PaymentMadeEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    emit(
      TaxiBookingLoadingState(
        state: PaymentNotInitializedState(
          booking: null,
          methodsAvailable: const [],
        ),
      ),
    );

    final TaxiBooking booking = await TaxiBookingStorage.addDetails(
      TaxiBooking.named(paymentMethod: event.paymentMethod),
    );

    final TaxiDriver taxiDriver = await TaxiBookingController.getTaxiDriver(
      booking,
    );

    emit(TaxiNotConfirmedState(booking: booking, driver: taxiDriver));

    await Future.delayed(const Duration(seconds: 1));

    emit(TaxiBookingConfirmedState(booking: booking, driver: taxiDriver));
  }

  Future<void> _onCancel(
    TaxiBookingCancelEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    emit(const TaxiBookingCancelledState());

    await Future.delayed(const Duration(milliseconds: 500));

    final List<Taxi> taxis = await TaxiBookingController.getTaxisAvailable();

    emit(TaxiBookingNotSelectedState(taxisAvailable: taxis));
  }

  Future<void> _onBackPressed(
    BackPressedEvent event,
    Emitter<TaxiBookingState> emit,
  ) async {
    final currentState = state;

    if (currentState is DetailsNotFilledState) {
      final List<Taxi> taxis = await TaxiBookingController.getTaxisAvailable();

      emit(TaxiBookingNotSelectedState(taxisAvailable: taxis));
      return;
    }

    if (currentState is PaymentNotInitializedState) {
      emit(TaxiNotSelectedState(booking: currentState.booking));
      return;
    }

    if (currentState is TaxiNotSelectedState) {
      emit(DetailsNotFilledState(booking: currentState.booking));
    }
  }
}
