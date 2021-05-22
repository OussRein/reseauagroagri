
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import '../models/annonce.dart';

class AnnoncesProvider with ChangeNotifier {
  List<Annonce> _annonces = [];
  String _authToken;
  String _userId;

  AnnoncesProvider(this._authToken, this._userId, this._annonces);

  List<Annonce> get products {
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
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('products');
    databaseReference.once().then((DataSnapshot snapshot) {
      if (snapshot.value == null) return;
      List<Annonce> products = [];
      snapshot.value.forEach((productId, productData) {
        products.add(Annonce(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          type: productData['type'] == 'Demande'
              ? TypeOfAnnonce.Demande
              : TypeOfAnnonce.Offre,
          creatorId: productData['creatorId'],
        ));
      });
      _annonces = products;
            print('Connected to second database and read $_annonces');
            notifyListeners();

    });
    
    /*try {
      String filterString =
          filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
      final url = Uri.parse(
          'https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$_authToken&$filterString');
      var response = await http.get(url);
      final data = json.decode(response.body);
      List<Product> products = [];
      if (data == null) return;
      data.forEach((productId, productData) {
        products.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          type: productData['type'] == 'Demande'
              ? TypeOfProduct.Demande
              : TypeOfProduct.Offre,
          creatorId: productData['creatorId'],
        ));
      });
      _products = products;
      notifyListeners();
    } catch (error) {
      print(error);
      return error;
    }*/
  }

  Future<void> addAnnonce(Annonce annonce) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('products');
    databaseReference.push().set(annonce.toJson());
    _annonces.add(annonce);
    /*try {
      final url = Uri.parse(
          'https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/annonce.json?auth=$_authToken');

      annonce.creatorIdValue = _userId;
      var response = await http.post(url, body: json.encode(annonce));

      var newProduct = Annonce(
        id: json.decode(response.body)['name'],
        description: product.description,
        imageUrl: product.imageUrl,
        type: product.type,
        price: product.price,
        title: product.title,
      );
      _annonces.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      return error;
    }*/
  }

  Future<void> updateAnnonce(Annonce product) async {
    final url = Uri.parse(
        'https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/products/${product.id}.json?auth=$_authToken');

    try {
      product.creatorIdValue = _userId;
      await http.patch(url, body: json.encode(product));
      final index = _annonces.indexWhere((element) => element.id == product.id);
      _annonces[index] = product;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      return error;
    }
  }

  void deleteAnnonce(String id) {
    final url = Uri.parse(
        'https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$_authToken');

    final index = _annonces.indexWhere((element) => element.id == id);
    var product = _annonces[index];

    try {
      _annonces.removeWhere((element) => element.id == id);
      notifyListeners();

      http.delete(url);
    } catch (error) {
      products.insert(index, product);
      notifyListeners();
      return error;
    }
  }

  Annonce findById(String id) {
    return _annonces.firstWhere((element) => element.id == id);
  }
}
