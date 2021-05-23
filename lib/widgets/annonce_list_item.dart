import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reseau_agroagri_app/pages/annonce_details_page.dart';
import '../pages/edit_annonce_page.dart';
import '../providers/annoncess_provider.dart';

class UserAnnonceItem extends StatelessWidget {
  final String _id;
  final String _title;
  final String _imageUrl;

  UserAnnonceItem(this._id, this._title, this._imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          AnnonceDetailsPage.ROUTE,
          arguments: _id,
        );
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_imageUrl),
      ),
      title: Text(_title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditAnnoncePage.ROUTE, arguments: _id);
              },
              color: Theme.of(context).primaryColorLight,
            ),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Provider.of<AnnoncesProvider>(context, listen: false).deleteAnnonce(_id);
                },
                color: Theme.of(context).errorColor),
          ],
        ),
      ),
    );
  }
}
