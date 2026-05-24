import 'dart:async';
import 'package:flutter/material.dart';
import '../../locator.dart';
import '../services/api.dart';
import '../models/productModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDModel extends ChangeNotifier {
  final Api _api = locator<Api>();

  List<Product> products = [];

  Future<List<Product>> fetchProducts() async {
    final result = await _api.getDataCollection();

    products = result.docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList();

    notifyListeners();
    return products;
  }

  Stream<List<Product>> fetchProductsAsStream() {
    return _api.streamDataCollection().map((snapshot) =>
        snapshot.docs
            .map((doc) => Product.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<Product> getProductById(String id) async {
    final doc = await _api.getDocumentById(id);

    return Product.fromMap(doc.data()!, doc.id);
  }

  Future<void> removeProduct(String id) async {
    await _api.removeDocument(id);
  }

  Future<void> updateProduct(Product data, String id) async {
    await _api.updateDocument(data.toJson(), id);
  }

  Future<void> addProduct(Product data) async {
    await _api.addDocument(data.toJson());
  }
}