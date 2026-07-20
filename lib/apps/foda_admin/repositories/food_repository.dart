import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/food.dart';
import '../models/result.dart';

class FoodRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Result<bool>> addFood(Food food) async {
    try {
      await _firestore.collection('foods').doc(food.id).set(food.toMap());
      return const Success(true);
    } catch (e) {
      return Failure(UnexpectedError(e.toString()));
    }
  }
}
