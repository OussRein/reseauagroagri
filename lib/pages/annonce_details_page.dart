import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reseau_agroagri_app/widgets/contacter_annonceur_box.dart';
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
      /*appBar: AppBar(
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
      ),*/
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            floating: true,
            snap: false,
            title: Text(
              _annonce.title,
              style: GoogleFonts.pacifico(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.none,
              background: Container(
                width: double.infinity,
                height: 350,
                child: Hero(
                  tag: _annonce.id,
                  child: Padding(
                    padding: EdgeInsets.only(top : MediaQuery.of(context).padding.top + AppBar().preferredSize.height),
                    child: FadeInImage(
                      placeholder:
                          AssetImage('assets/images/Shop_ICON_Final.jpg'),
                      image: NetworkImage(_annonce.imageUrl),
                      fit: BoxFit.cover,
                      height: 350,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
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
                      _annonce.dateCreation == null
                          ? "Date : ${DateTime.now().toString()}"
                          : "Date : ${_annonce.dateCreation.toString()}",
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
          ])),
        ],
      ),
      bottomNavigationBar: Offstage(
        offstage: FirebaseAuth.instance.currentUser.uid == _annonce.creatorId,
        child: ContacterAnnonceurBox(_annonce.creatorId),
      ),
    );
  }
}
