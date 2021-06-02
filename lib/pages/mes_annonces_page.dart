import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reseau_agroagri_app/models/annonce.dart';
import 'edit_annonce_page.dart';
import '../providers/annoncess_provider.dart';
import '../widgets/annonce_list_item.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  Demandes,
  Offres,
  All,
}

class MesAnnoncesPage extends StatefulWidget {
  static const String ROUTE = "/user-products-page";

  @override
  _MesAnnoncesPageState createState() => _MesAnnoncesPageState();
}

class _MesAnnoncesPageState extends State<MesAnnoncesPage> {
  var _afficherDemandes = true;

  var _afficherOffres = true;

  List<Annonce> typeOfAnnonces(AnnoncesProvider annoncesData) {
    if (_afficherDemandes && _afficherOffres) {
      return annoncesData.mesAnnonces;
    } else if (_afficherOffres) {
      return annoncesData.mesOffres;
    } else {
      return annoncesData.mesDemandes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final annonces = Provider.of<AnnoncesProvider>(context);
    var mesAnnonces = typeOfAnnonces(annonces);
    return Scaffold(
      appBar: AppBar(
        title: Text("Vos Annonces!"),
        actions: [
          
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditAnnoncePage.ROUTE);
            },
          ),
          PopupMenuButton(
            onSelected: (FilterOptions filterOptions) {
              setState(() {
                if (filterOptions == FilterOptions.All) {
                  //productsData.showFavouritesOnly();
                  _afficherDemandes = true;
                  _afficherOffres = true;
                } else if (filterOptions == FilterOptions.Demandes) {
                  //productsData.showAll();
                  _afficherDemandes = true;
                  _afficherOffres = false;
                } else {
                  _afficherDemandes = false;
                  _afficherOffres = true;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Afficher tout"),
                value: FilterOptions.All,
                textStyle: _afficherDemandes == true && _afficherOffres == true
                    ? TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16)
                    : null,
                enabled: _afficherDemandes == true && _afficherOffres == true
                    ? false
                    : true,
              ),
              PopupMenuItem(
                child: Text("Filtrer les Demandes"),
                value: FilterOptions.Demandes,
                textStyle: _afficherDemandes == true && _afficherOffres == false
                    ? TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16)
                    : null,
                enabled: _afficherDemandes == true && _afficherOffres == false
                    ? false
                    : true,
              ),
              PopupMenuItem(
                child: Text("Filtrer les Offres"),
                value: FilterOptions.Offres,
                textStyle: _afficherDemandes == false && _afficherOffres == true
                    ? TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16)
                    : null,
                enabled: _afficherDemandes == false && _afficherOffres == true
                    ? false
                    : true,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<AnnoncesProvider>(context, listen: false)
            .fetchAnnonces(true),
        builder: (ctx, future) => RefreshIndicator(
          onRefresh: () {
            return Provider.of<AnnoncesProvider>(context, listen: false)
                .fetchAnnonces(true);
          },
          child: Consumer<AnnoncesProvider>(
            builder: (ctx, data, _) => Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemBuilder: (_, i) => Column(
                  children: [
                    UserAnnonceItem(mesAnnonces[i].id, mesAnnonces[i].title,
                        mesAnnonces[i].imageUrl),
                    Divider(),
                  ],
                ),
                itemCount: mesAnnonces.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
