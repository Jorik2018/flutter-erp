import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/openflutterecommerce/config/theme.dart';

class FilterSelectableItem extends StatelessWidget {
  final bool isSelected;
  final String text;

  const FilterSelectableItem({
    Key? key,
    this.isSelected = false,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.linePadding),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.sidePadding,
          horizontal: AppSizes.sidePadding,
        ),
        child: Text(text),
      ),
    );
  }
}
