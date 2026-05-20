import 'package:flutter_erp/apps/fu_uber/core/models/google_places/prediction.dart';

class PlacesAutocompleteResponse {

  final List<Prediction> predictions;

  final String status;

  PlacesAutocompleteResponse({
    required this.predictions,
    required this.status,
  });

  factory PlacesAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlacesAutocompleteResponse(
      predictions: (json['predictions'] as List)
          .map((e) => Prediction.fromJson(e))
          .toList(),
      status: json['status'],
    );
  }

}