import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/annonce.dart';
import '../pages/annonce_details_page.dart';

class AnnonceItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final annonce = Provider.of<Annonce>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AnnonceDetailsPage.ROUTE,
          arguments: annonce.id,
        );
      },
      child: GridTile(
        child: Hero(
          tag: annonce.id,
          child: FadeInImage(
            placeholder: AssetImage('assets/images/Shop_ICON_Final.jpg'),
            image: NetworkImage(annonce.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          subtitle: Expanded(
            child: Text(
              annonce.description,
              style: GoogleFonts.lato(
                textStyle: TextStyle(color: Colors.white),
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                decorationStyle: TextDecorationStyle.solid,
                shadows: [
                  Shadow(
                      // bottomLeft
                      offset: Offset(-1, -1),
                      color: Colors.black),
                  Shadow(
                      // bottomRight
                      offset: Offset(1, -1),
                      color: Colors.black),
                  Shadow(
                      // topRight
                      offset: Offset(0.5, 0.5),
                      color: Colors.black),
                  Shadow(
                      // topLeft
                      offset: Offset(-0.5, 0.5),
                      color: Colors.black),
                ],
              ),
              overflow: TextOverflow.fade,
            ),
          ),
          title: Text(
            annonce.title,
            maxLines: 2,
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.white),
              fontSize: 21,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              shadows: [
                  Shadow(
                      // bottomLeft
                      offset: Offset(-1.5, -1.5),
                      color: Colors.black),
                  Shadow(
                      // bottomRight
                      offset: Offset(1.5, -1.5),
                      color: Colors.black),
                  Shadow(
                      // topRight
                      offset: Offset(1.5, 1.5),
                      color: Colors.black),
                  Shadow(
                      // topLeft
                      offset: Offset(-1.5, 1.5),
                      color: Colors.black),
                ],
            ),
          ),
        ),
      ),
    );
  }
}
