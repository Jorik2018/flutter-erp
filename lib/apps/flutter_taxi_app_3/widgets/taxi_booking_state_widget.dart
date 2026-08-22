import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/bloc/taxi_booking_bloc.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/bloc/taxi_booking_state.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/widgets/dashed_line.dart';
import 'package:flutter_erp/apps/flutter_taxi_app_3/widgets/taxi_booking_cancellation_dialog.dart';

class TaxiBookingStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaxiBookingBloc, TaxiBookingState>(
      builder: (context, state) {
        var selectedTab = 1;
        var title = '';

        final TaxiBookingState currentState = state is TaxiBookingLoadingState
            ? state.state
            : state;

        if (currentState is DetailsNotFilledState) {
          selectedTab = 1;
          title = 'New Destination';
        } else if (currentState is TaxiNotSelectedState) {
          selectedTab = 2;
          title = 'Choose Ride';
        } else if (currentState is PaymentNotInitializedState) {
          selectedTab = 3;
          title = 'Payment Method';
        } else if (currentState is TaxiNotConfirmedState) {
          selectedTab = 4;
          title = 'Ride Info';
        }
        return Container(
          color: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => TaxiBookingCancellationDialog(),
                      );
                    },
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              Row(
                children: [
                  buildTab(context, "1", selectedTab >= 1),
                  Expanded(
                    child: DashedLine(color: Colors.white.withOpacity(0.3)),
                  ),
                  buildTab(context, "2", selectedTab >= 2),
                  Expanded(
                    child: DashedLine(color: Colors.white.withOpacity(0.3)),
                  ),
                  buildTab(context, "3", selectedTab >= 3),
                  Expanded(
                    child: DashedLine(color: Colors.white.withOpacity(0.3)),
                  ),
                  buildTab(context, "4", selectedTab >= 4),
                ],
              ),
              SizedBox(height: 12.0),
            ],
          ),
        );
      },
    );
  }

  Widget buildTab(BuildContext context, String val, bool enabled) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        "$val",
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: enabled ? Colors.black : Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }
}
