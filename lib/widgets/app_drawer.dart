import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reseau_agroagri_app/models/language_data.dart';
import 'package:reseau_agroagri_app/models/languages.dart';
import 'package:reseau_agroagri_app/models/locale_constant.dart';
import 'package:reseau_agroagri_app/pages/contact_page.dart';
import 'package:reseau_agroagri_app/pages/mes_annonces_page.dart';
import 'package:reseau_agroagri_app/pages/profile_page.dart';
import 'package:reseau_agroagri_app/services/base_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              "ReseauAgroagri.Com",
              style: GoogleFonts.pacifico(),
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text(
              Languages.of(context).annoncesLabel,
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(
              Languages.of(context).mesAnnoncesLabel,
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(MesAnnoncesPage.ROUTE);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(
              Languages.of(context).profileLabel,
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(ProfilePage.ROUTE);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.alternate_email),
            title: Text(
              Languages.of(context).contactLabel,
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(ContactPage.ROUTE);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(
              Languages.of(context).labelSelectLanguage,
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            onTap: () {
              showAlertDialog(context);
            },
          ),
          
          Divider(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  Languages.of(context).disconnectLabel,
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                  FireAuth fireAuth = new FireAuth();
                  fireAuth.signOut();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {

          return AlertDialog(
            title: Text(Languages.of(context).labelSelectLanguage),
            content: DropdownButton<LanguageData>(
              iconSize: 30,
              onChanged: (LanguageData language) {
                changeLanguage(context, language.languageCode);
               
              },
              items: LanguageData.languageList()
                  .map<DropdownMenuItem<LanguageData>>(
                    (e) => DropdownMenuItem<LanguageData>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.flag,
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(e.name)
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
  }
    );}
}
