import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';

const List<String> _supportedLanguages = ['en', 'ru'];

class GlobalTranslations {
  factory GlobalTranslations() => _translations;

  GlobalTranslations._internal();

  late Locale _locale;
  Map<dynamic, dynamic>? _localizedValues;
  late void Function(String) onLocaleChangedCallback;

  Iterable<Locale> supportedLocales() =>
      _supportedLanguages.map<Locale>((lang) => Locale(lang, ''));

  String? text(String key) {
    if (_localizedValues == null) {
      return 'No localization for $key';
    }

    if (_localizedValues?[key] == null) {
      return '** $key not found';
    } else {
      return _localizedValues?[key].toString();
    }
  }

  String get currentLanguage => _locale.languageCode;

  Locale get locale => _locale;

  Future<dynamic> setLanguage(String language) async {
    var lang = 'en';
    if (_supportedLanguages.contains(language)) {
      lang = language;
    }

    _locale = Locale(lang, '');

    final jsonContent = await rootBundle.loadString('locale/i18n_${_locale.languageCode}.json');
    _localizedValues = json.decode(jsonContent) as Map;
    onLocaleChangedCallback(language);

    return null;
  }

  static final GlobalTranslations _translations = GlobalTranslations._internal();
}

GlobalTranslations t = GlobalTranslations();