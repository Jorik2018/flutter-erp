import 'package:flutter_erp/apps/openflutterecommerce/data/model/category.dart';

class CategoriesByFilterResult {
  final List<ProductCategory> categories;
  final int quantity;
  final Exception exception;

  CategoriesByFilterResult(this.categories, this.quantity, {this.exception});

  bool get validResults => exception == null;
}
