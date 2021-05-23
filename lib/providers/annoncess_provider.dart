import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/annonce.dart';

class AnnoncesProvider with ChangeNotifier {
  List<Annonce> _annonces = [];

  AnnoncesProvider(this._annonces);

  List<Annonce> get annonces {
    return [..._annonces];
  }

  List<Annonce> get demandes {
    return _annonces
        .where((element) => element.type == TypeOfAnnonce.Demande)
        .toList();
  }

  List<Annonce> get offres {
    return _annonces
        .where((element) => element.type == TypeOfAnnonce.Offre)
        .toList();
  }

  Future<void> fetchAnnonces([bool filterByUser = false]) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('products');
    databaseReference.once().then((DataSnapshot snapshot) {
      if (snapshot.value == null) return;
      List<Annonce> products = [];
      snapshot.value.forEach((annonceId, annonceData) {
        products.add(Annonce(
          id: annonceId,
          title: annonceData['title'],
          description: annonceData['description'],
          imageUrl: annonceData['imageUrl'],
          price: (annonceData['price'] as num)?.toDouble(),
          reference: annonceData['reference'],
          type: annonceData['type'] == 'Demande'
              ? TypeOfAnnonce.Demande
              : TypeOfAnnonce.Offre,
          creatorId: annonceData['creatorId'],
          dateCreation: DateTime.parse(annonceData['dateCreation']),
        ));
      });
      _annonces = products;
      print('Connected to second database and read $_annonces');
      notifyListeners();
    });
  }

  Future<void> addAnnonce(Annonce annonce) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('products');
    databaseReference.push().set(annonce.toJson());
    _annonces.add(annonce);
  }

  Future<void> updateAnnonce(Annonce annonce) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('products');
    databaseReference.update(annonce.toJson());
    _annonces.add(annonce);
    final index = _annonces.indexWhere((element) => element.id == annonce.id);
    _annonces[index] = annonce;
    notifyListeners();
  }

  void deleteAnnonce(String id) {
    final index = _annonces.indexWhere((element) => element.id == id);
    var product = _annonces[index];
    try {
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference().child('products');
      databaseReference.child('$id').remove();

      _annonces.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (error) {
      _annonces.insert(index, product);
      notifyListeners();
      return error;
    }
  }

  Annonce findById(String id) {
    return _annonces.firstWhere((element) => element.id == id);
  }
}
