
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/fu_uber/core/models/google_places/prediction.dart';

class PredictionItemView extends StatelessWidget {

  final Prediction? prediction;

  const PredictionItemView({Key? key, this.prediction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          prediction!.description!,
        ),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }

}
