import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_bloc.dart';
import 'package:taxi_app/bloc/taxi_booking_event.dart';

class TaxiBookingCancellationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Cancel Ride"),
      content: Text("Do you want to cancel ride?"),
      actions: <Widget>[
        TextButton(
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: 16.0),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            "Ok",
            style: TextStyle(fontSize: 16.0),
          ),
          onPressed: () {
            BlocProvider.of<TaxiBookingBloc>(context)
                .add(TaxiBookingCancelEvent());
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
