import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reseau_agroagri_app/pages/messages_page.dart';
import 'package:reseau_agroagri_app/providers/annoncess_provider.dart';
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
  bool _isSearching;
  String _searchText = "";

  @override
  void initState() {
    _isLoading = true;
    Provider.of<AnnoncesProvider>(context, listen: false)
        .fetchAnnonces()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  Icon actionIcon = Icon(
    Icons.search,
  );

  Widget appBarTitle =
      Text("ReseauAgroagri.Com", style: GoogleFonts.pacifico(fontSize: 14));

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = Icon(
        Icons.search,
      );
      this.appBarTitle =
          Text("ReseauAgroagri.Com", style: GoogleFonts.pacifico(fontSize: 14));
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: [
          IconButton(
            icon: this.actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = Icon(
                    Icons.close,
                  );
                  this.appBarTitle = TextField(
                    
                    onChanged: (value) {
                      return setState(() {
                        _searchText = value;
                      });
                    },
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                        hintText: "Chercher..",
                        hintStyle: TextStyle(color: Colors.white)),
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
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
                textStyle: _afficherDemandes == false && _afficherOffres == false
                    ? TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16)
                    : null,
                enabled: _afficherDemandes == false && _afficherOffres == true
                    ? false
                    : true,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
          IconButton(
            icon: Icon(
              Icons.message,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(MassagesPage.ROUTE);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
                return Provider.of<AnnoncesProvider>(context, listen: false)
                    .fetchAnnonces();
              },
              child: AnnoncesGrid(
                  _afficherDemandes, _afficherOffres, _searchText)),
    );
  }
}
