import 'package:flutter/material.dart';
import 'package:reseau_agroagri_app/models/annonce.dart';

import '../providers/annoncess_provider.dart';
import 'annonce_item.dart';
import 'package:provider/provider.dart';

class AnnoncesGrid extends StatelessWidget {

  final bool _afficherDemandes;
  final bool _afficherOffres;

  AnnoncesGrid(this._afficherDemandes, this._afficherOffres);

  List<Annonce> typeOfProducts(AnnoncesProvider productsData){
    if(_afficherDemandes && _afficherOffres) {
      return productsData.products;
    }else if (_afficherOffres){
      return productsData.offres;
    }else {
      return productsData.demandes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<AnnoncesProvider>(context);
    final products = typeOfProducts(productsData);
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        //create: (cntx) => products[i],
        child: AnnonceItem(),
      ),
      itemCount: products.length,
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
