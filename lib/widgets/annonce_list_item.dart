import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/edit_annonce_page.dart';
import '../providers/annoncess_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String _title;
  final String _imageUrl;

  UserProductItem(this.id, this._title, this._imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
                    .pushNamed(EditAnnoncePage.ROUTE, arguments: id);
              },
              color: Theme.of(context).primaryColorLight,
            ),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Provider.of<AnnoncesProvider>(context, listen: false).deleteAnnonce(id);
                },
                color: Theme.of(context).errorColor),
          ],
        ),
      ),
    );
  }
}
