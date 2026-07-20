import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_custom_path_drawer/common/color_constants.dart';

class TextButtonWidget extends StatelessWidget {
  final String btnTxt;
  final VoidCallback? btnOnTap;

  TextButtonWidget({Key? key, required this.btnTxt, required this.btnOnTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
      child: TextButton(
        onPressed: btnOnTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                btnTxt,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
