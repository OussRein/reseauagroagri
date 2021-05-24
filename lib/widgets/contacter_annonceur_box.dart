import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ContacterAnnonceurBox extends StatefulWidget {
  @override
  _ContacterAnnonceurBoxState createState() => _ContacterAnnonceurBoxState();
}

class _ContacterAnnonceurBoxState extends State<ContacterAnnonceurBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        child: InkWell(
          onTap: () => showAlertDialog(context),
          child: Ink(
            color: Theme.of(context).primaryColorDark,
            child: Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.contacts_sharp,
                    ),
                  ),
                  Text(
                    "Contacter l'annonceur",
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Future<bool> showAlertDialog(BuildContext context) {
    return Alert(
        context: context,
        title: "Contacter l'annonceur",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.title),
                labelText: 'Titre',
              ),
            ),
            TextField(
              maxLines: 6,
              decoration: InputDecoration(
                icon: Icon(Icons.info),
                labelText: 'Informations',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Envoyer le message",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}