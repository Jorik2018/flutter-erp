import 'package:meta/meta.dart';
import 'package:tourism_demo/models/destination.dart';

class RefreshDestinationsAction {}

class FetchDestinationsAction {}

class ReceivedDestinationsAction {

  final List<Destination> destinations;

  ReceivedDestinationsAction({required this.destinations});

}

class ErrorLoadingDestinationsAction {

  final String errorStr;

  ErrorLoadingDestinationsAction({required this.errorStr});

}
