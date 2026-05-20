import 'package:flutter_erp/apps/fu_uber/core/models/google_places/structured_formatting.dart';

class Prediction {
  final String description;
  final String placeId;
  final StructuredFormatting? structuredFormatting;

  Prediction({
    required this.description,
    required this.placeId,
    this.structuredFormatting,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json['description'],
      placeId: json['place_id'],
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
    );
  }
}