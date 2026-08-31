import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppTranslations {
  final Locale locale;

  static Map<String, dynamic> _localisedValues = {};

  AppTranslations(this.locale);

  static AppTranslations? of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  static Future<AppTranslations> load(Locale locale) async {
    final appTranslations = AppTranslations(locale);

    final jsonContent = await rootBundle.loadString(
      "assets/locale/localization_${locale.languageCode}.json",
    );

    _localisedValues = json.decode(jsonContent) as Map<String, dynamic>;

    return appTranslations;
  }

  String get currentLanguage => locale.languageCode;

  String text(String key) {
    return _localisedValues[key]?.toString() ?? "$key not found";
  }
}
