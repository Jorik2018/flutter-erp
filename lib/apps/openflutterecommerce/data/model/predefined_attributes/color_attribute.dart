import 'dart:ui';

import 'package:flutter_erp/apps/openflutterecommerce/data/model/product_attribute.dart';

class ColorAttribute extends ProductAttribute {
  final Map<String, Color> visibleColors;

  ColorAttribute({int? id, String? info, this.visibleColors})
    : super(id: id, name: 'Color', info: info, options: visibleColors.keys);
}
