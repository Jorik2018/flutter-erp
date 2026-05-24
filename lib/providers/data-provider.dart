import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  await Future.delayed(const Duration(seconds: 2)); // simulate network

  return ["Item A", "Item B", "Item C", "Item D"];
});