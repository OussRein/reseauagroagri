import 'package:flutter/material.dart';

abstract class Languages {
  
  static Languages of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get annoncesLabel;

  String get mesAnnoncesLabel;

  String get profileLabel;

  String get disconnectLabel;

  String get contactLabel;

  String get appName;

  String get labelWelcome;

  String get labelInfo;

  String get labelSelectLanguage;

  String get vosAnnoncesLabel;

  String get deposerAnnonceLabel;

  String get editAnnonceLabel;

  String get sauvgarderLabel;

  String get afficherToutLabel;

  String get filterLesDemandesLabel;

  String get filtrerLesOffresLabel;

  String get informationPersonellesLabel;

  String get usernameLabel;

  String get emailLabel;

  String get annulerLabel;


}