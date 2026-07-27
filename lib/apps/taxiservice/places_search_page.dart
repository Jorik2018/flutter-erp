import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';

import 'order_page.dart';

const String kGoogleApiKey = String.fromEnvironment('GOOGLE_PLACES_API_KEY');

double? lat;
double? lng;

class CustomSearchScaffold extends StatefulWidget {
  const CustomSearchScaffold({super.key});

  @override
  State<CustomSearchScaffold> createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends State<CustomSearchScaffold> {
  final TextEditingController _searchController = TextEditingController();

  bool _isProcessingPrediction = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectPrediction(Prediction prediction) {
    final description = prediction.description?.trim() ?? '';

    if (description.isEmpty) {
      return;
    }

    _searchController
      ..text = description
      ..selection = TextSelection.collapsed(offset: description.length);
  }

  void _receivePredictionWithCoordinates(Prediction prediction) {
    if (_isProcessingPrediction) {
      return;
    }

    final description = prediction.description?.trim() ?? '';
    final selectedLat = double.tryParse(prediction.lat ?? '');
    final selectedLng = double.tryParse(prediction.lng ?? '');

    if (description.isEmpty || selectedLat == null || selectedLng == null) {
      _showMessage('No fue posible obtener las coordenadas de la dirección.');
      return;
    }

    _isProcessingPrediction = true;

    lat = selectedLat;
    lng = selectedLng;

    if (fromfieldPressed!) {
      fromAddress
        ..text = description
        ..selection = TextSelection.collapsed(offset: description.length);

      fromLat = selectedLat;
      fromLong = selectedLng;

      debugPrint('Dirección de origen: $description');
      debugPrint('Coordenadas de origen: $selectedLat, $selectedLng');
    } else {
      toAddress
        ..text = description
        ..selection = TextSelection.collapsed(offset: description.length);

      toLat = selectedLat;
      toLong = selectedLng;

      // Si esta variable pertenece al State de order_page.dart,
      // es preferible actualizarla dentro del setState de esa pantalla.
      locationIconColor = Colors.blue;

      debugPrint('Dirección de destino: $description');
      debugPrint('Coordenadas de destino: $selectedLat, $selectedLng');
    }

    if (mounted) {
      Navigator.of(context).pop();
    }

    _isProcessingPrediction = false;
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: GooglePlacesAutoCompleteTextFormField(
          textEditingController: _searchController,
          config: GoogleApiConfig(
            apiKey: kGoogleApiKey,

            // Código ISO 3166-1 alpha-2 de Uzbekistán.
            countries: const ['uz'],

            // Código de idioma BCP-47/ISO corto.
            languageCode: 'ru',

            // Hace que Prediction incluya lat y lng.
            fetchPlaceDetailsWithCoordinates: true,

            debounceTime: 500,
          ),
          autofocus: true,
          minInputLength: 2,
          maxHeight: 300,
          decoration: const InputDecoration(
            hintText: 'Buscar una dirección',
            border: InputBorder.none,
            filled: true,
          ),
          onSuggestionClicked: _selectPrediction,
          onPredictionWithCoordinatesReceived:
              _receivePredictionWithCoordinates,
          onError: (error) {
            debugPrint('Error de Google Places: $error');

            _showMessage('Ocurrió un error al buscar la dirección.');
          },
          predictionsEmptyWidget: const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No se encontraron direcciones'),
          ),
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Escribe una dirección en el campo superior y selecciona '
            'una de las sugerencias.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
