import 'dart:async';

import 'package:redux/redux.dart';
import 'package:flutter_erp/apps/tourism_demo/models/destination.dart';
import 'package:flutter_erp/apps/tourism_demo/networking/server_api.dart';
import 'package:flutter_erp/apps/tourism_demo/redux/app/app_state.dart';
import 'package:flutter_erp/apps/tourism_demo/redux/destinations/destinations_actions.dart';

class DestinationsMiddleware extends MiddlewareClass<AppState> {
  DestinationsMiddleware(this.api);

  final ServerAPI api;

  @override
  Future<Null> call(
    Store<AppState> store,
    dynamic action,
    NextDispatcher next,
  ) async {
    next(action);
    if (action is FetchDestinationsAction) {
      print(action);
      _fetchDestinations(next)
          .then(
            (destinations) =>
                next(ReceivedDestinationsAction(destinations: destinations)),
          )
          .catchError(
            (e) => next(ErrorLoadingDestinationsAction(errorStr: e.toString())),
          );
    }
  }

  Future<List<Destination>> _fetchDestinations(NextDispatcher next) async {
    return await api.fetchDestinations();
  }
}
