import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_annonce_page.dart';
import '../providers/annoncess_provider.dart';
import '../widgets/annonce_list_item.dart';
import '../widgets/app_drawer.dart';

class MesAnnoncesPage extends StatelessWidget {
  static const String ROUTE = "/user-products-page";

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<AnnoncesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products!"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {Navigator.of(context).pushNamed(EditAnnoncePage.ROUTE);},
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<AnnoncesProvider>(context, listen: false).fetchAnnonces(true),
        builder:  (ctx, future) => RefreshIndicator(
          onRefresh: () { return Provider.of<AnnoncesProvider>(context, listen: false).fetchAnnonces(true);},
            child: Consumer<AnnoncesProvider>(
            builder: (ctx, data, _ ) => Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemBuilder: (_, i) => Column(
                  children: [
                    UserProductItem(
                        products.products[i].id, products.products[i].title, products.products[i].imageUrl),
                    Divider(),
                  ],
                ),
                itemCount: products.products.length,
              ),
          ),
            ),
        ),
      ),
    );
  }
}
