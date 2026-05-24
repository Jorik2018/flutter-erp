import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_web_admin_dashboard/common/app_colors.dart';

class SettingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        color: AppColors.txtGry,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.settings,
      ),
    );
  }
}
