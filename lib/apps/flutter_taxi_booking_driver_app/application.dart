import 'dart:ui';

class Application {
  static final Application _application = Application._internal();

  factory Application() {
    return _application;
  }

  Application._internal();

  final List<String> supportedLanguages = ["English", "French"];

  final List<String> supportedLanguagesCodes = ["en", "fr"];

  // Returns the list of supported Locales
  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language));

  // Function to be invoked when changing the language
  LocaleChangeCallback? onLocaleChanged;
}

final Application application = Application();

typedef LocaleChangeCallback = void Function(Locale locale);
