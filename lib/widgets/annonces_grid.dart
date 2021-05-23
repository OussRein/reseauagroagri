import 'package:flutter/material.dart';
import 'package:reseau_agroagri_app/models/annonce.dart';

import '../providers/annoncess_provider.dart';
import 'annonce_item.dart';
import 'package:provider/provider.dart';

class AnnoncesGrid extends StatelessWidget {

  final bool _afficherDemandes;
  final bool _afficherOffres;

  AnnoncesGrid(this._afficherDemandes, this._afficherOffres);

  List<Annonce> typeOfAnnonces(AnnoncesProvider annoncesData){
    if(_afficherDemandes && _afficherOffres) {
      return annoncesData.annonces;
    }else if (_afficherOffres){
      return annoncesData.offres;
    }else {
      return annoncesData.demandes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final annoncesData = Provider.of<AnnoncesProvider>(context);
    final annonces = typeOfAnnonces(annoncesData);
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: annonces[i],
        //create: (cntx) => annonces[i],
        child: AnnonceItem(),
      ),
      itemCount: annonces.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 2/3,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisExtent: 200,
        mainAxisSpacing: 20,
      ),
    );
  }
}
