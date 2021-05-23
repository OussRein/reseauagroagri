import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/annoncess_provider.dart';

class AnnonceDetailsPage extends StatelessWidget {
  static const String ROUTE = "/product-detail-page";
  @override
  Widget build(BuildContext context) {
    final _annonceId = ModalRoute.of(context).settings.arguments as String;
    final _annonce = Provider.of<AnnoncesProvider>(
      context,
      listen: false,
    ).findById(_annonceId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          _annonce.title,
          style: GoogleFonts.pacifico(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 350,
              child: Image.network(
                _annonce.imageUrl,
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _annonce.title,
                      style: GoogleFonts.lato(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Ref : ${_annonce.reference}",
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Chip(
                          label: Text(
                            "Prix Unitaire : \$${_annonce.price}",
                          ),
                          backgroundColor: Theme.of(context).primaryColorLight,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _annonce.dateCreation == null ? "Date : ${DateTime.now().toString()}" : "Date : ${_annonce.dateCreation.toString()}",
                      style: GoogleFonts.lato(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text.rich(
                  TextSpan(
                    text: 'Description:  ',
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' ${_annonce.description} ',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.blue,
                            fontSize: 18,
                            height: 1.3,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: InkWell(
          onTap: () => print("Contacter l'annonceur"),
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
      ),
    );
  }
}
