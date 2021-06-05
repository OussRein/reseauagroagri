
import 'package:flutter/material.dart';
import 'package:reseau_agroagri_app/models/language_ar.dart';
import 'package:reseau_agroagri_app/models/language_fr.dart';
import 'package:reseau_agroagri_app/models/languages.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {

  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['fr', 'ar'].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) => _load(locale);

  static Future<Languages> _load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageFr();
      case 'ar':
        return LanguageAr();
      default:
        return LanguageFr();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
}