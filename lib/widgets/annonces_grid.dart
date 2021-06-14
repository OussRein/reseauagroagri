import 'package:flutter/material.dart';
import 'package:reseau_agroagri_app/models/annonce.dart';

import '../providers/annoncess_provider.dart';
import 'annonce_item.dart';
import 'package:provider/provider.dart';

class AnnoncesGrid extends StatelessWidget {

  final bool _afficherDemandes;
  final bool _afficherOffres;
  final String filterWord;

  AnnoncesGrid(this._afficherDemandes, this._afficherOffres, this.filterWord);

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
    var annonces = typeOfAnnonces(annoncesData);
    annonces = annonces
        .where((element) => element.title.toLowerCase().contains(filterWord.toLowerCase()))
        .toList();
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
        mainAxisExtent: 250,
        mainAxisSpacing: 20,
      ),
    );
  }
}
