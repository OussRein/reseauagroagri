import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reseau_agroagri_app/providers/products_provider.dart';
import 'package:reseau_agroagri_app/widgets/annonces_grid.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  Demandes,
  Offres,
  All,
}


class HomePage extends StatefulWidget {

  static const String ROUTE = '/home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var _afficherDemandes = true;
  var _afficherOffres = true;
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProducts()
        .then((value) {
          
            setState(() {
              _isLoading = false;
            });
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ReseauAgroagri.Com", style: GoogleFonts.pacifico()),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions filterOptions) {
              setState(() {
                if (filterOptions == FilterOptions.All) {
                  //productsData.showFavouritesOnly();
                  _afficherDemandes = true;
                  _afficherOffres = true;
                } else if (filterOptions == FilterOptions.Demandes){
                  //productsData.showAll();
                  _afficherDemandes = true;
                  _afficherOffres = false;
                }else {
                  _afficherDemandes = false;
                  _afficherOffres = true;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Afficher tout"),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: Text("Filtrer les Demandes"),
                value: FilterOptions.Demandes,
              ),
              PopupMenuItem(
                child: Text("Filtrer les Offres"),
                value: FilterOptions.Offres,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
          
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {return Provider.of<ProductProvider>(context, listen: false)
                    .fetchProducts();},
              child: AnnoncesGrid(_afficherDemandes,_afficherOffres)),
    );
  }
}