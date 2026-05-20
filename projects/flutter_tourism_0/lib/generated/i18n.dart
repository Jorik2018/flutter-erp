import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class S extends WidgetsLocalizations {
  late Locale _locale;
  late String _lang;

  S(this._locale) {
    _lang = getLang(_locale);
    print('Current locale: $_lang');
  }

  static final GeneratedLocalizationsDelegate delegate =
      new GeneratedLocalizationsDelegate();

  static S of(BuildContext context) {
    var s = Localizations.of<S>(context, WidgetsLocalizations);
    s!._lang = getLang(s._locale);
    return s;
  }

  @override
  TextDirection get textDirection => TextDirection.ltr;
  
  @override
  // TODO: implement reorderItemDown
  String get reorderItemDown => 'Reorder Item Down';
  
  @override
  // TODO: implement reorderItemLeft
  String get reorderItemLeft => 'Reorder Item Left';
  
  @override
  // TODO: implement reorderItemRight
  String get reorderItemRight => 'Reorder Item Right';
  
  @override
  // TODO: implement reorderItemToEnd
  String get reorderItemToEnd => 'Reorder Item To End';
  
  @override
  // TODO: implement reorderItemToStart
  String get reorderItemToStart => throw UnimplementedError();
  
  @override
  // TODO: implement reorderItemUp
  String get reorderItemUp => throw UnimplementedError();

}

class en extends S {
  en(Locale locale) : super(locale);
}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<WidgetsLocalizations> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return [
      new Locale("en", ""),
    ];
  }

  LocaleResolutionCallback resolution({Locale? fallback}) {
    return (Locale? locale, Iterable<Locale>? supported) {
      var languageLocale = new Locale(locale!.languageCode, "");
      if (supported!.contains(locale))
        return locale;
      else if (supported.contains(languageLocale))
        return languageLocale;
      else {
        var fallbackLocale = fallback ?? supported.first;
        return fallbackLocale;
      }
    };
  }

  Future<WidgetsLocalizations> load(Locale locale) {
    String lang = getLang(locale);
    switch (lang) {
      case "en":
        return new SynchronousFuture<WidgetsLocalizations>(new en(locale));
      default:
        return new SynchronousFuture<WidgetsLocalizations>(new S(locale));
    }
  }

  bool isSupported(Locale locale) => supportedLocales.contains(locale);

  bool shouldReload(GeneratedLocalizationsDelegate old) => false;
}

String getLang(Locale l) => l.countryCode != null && l.countryCode!.isEmpty
    ? l.languageCode
    : l.toString();