import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reseau_agroagri_app/pages/contact_page.dart';
import 'package:reseau_agroagri_app/pages/mes_annonces_page.dart';
import 'package:reseau_agroagri_app/providers/auth.dart';

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
              "Shop",
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
              "Mes annonces",
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
              "Profile",
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
            leading: Icon(Icons.alternate_email),
            title: Text(
              "Nous contacter",
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ContactPage.ROUTE);
            },
          ),
          Divider(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  "Déconnexion",
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<Auth>(context, listen: false).logout();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
