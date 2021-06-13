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
          backgroundColor: Colors.blue.shade400.withOpacity(0.5),
          title: Text(
            annonce.title,
            style: GoogleFonts.lato(
              textStyle: TextStyle(color: Colors.black),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}
