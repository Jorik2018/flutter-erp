import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:intl/intl_standalone.dart';
/**error: Target of URI doesn't exist: 'package:flutter_gen/gen_l10n/app_localizations.dart'.
Try creating the file referenced by the URI, or try using a URI for a file that does exist. */
import 'package:flutter_erp/apps/wonders/l10n/app_localizations.dart';

class LocaleLogic {
  /**error:Undefined class 'AppLocalizations'.
Try changing the name to the name of an existing class, or creating a class with the name 'AppLocalizations */
  AppLocalizations? _strings;
  AppLocalizations get strings => _strings!;

  bool get isLoaded => _strings != null;

  Future<void> load() async {
    final localeCode = await findSystemLocale();
    Locale locale = Locale(localeCode.split('_')[0]);
    if (kDebugMode) {
      // Uncomment for testing in chinese
      // locale = Locale('zh');
    }
    if (AppLocalizations.supportedLocales.contains(locale) == false) {
      locale = Locale('en');
    }
    _strings = await AppLocalizations.delegate.load(locale);
  }
}
