import 'dart:collection';

import 'package:flutter_erp/apps/openflutterecommerce/data/model/product.dart';
import 'package:flutter_erp/apps/openflutterecommerce/data/model/product_attribute.dart';

class FavoriteProduct {
  final Product product;
  final HashMap<ProductAttribute, String>? favoriteForm;

  FavoriteProduct(this.product, this.favoriteForm);
}
