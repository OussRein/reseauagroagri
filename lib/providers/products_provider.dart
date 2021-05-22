
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  String _authToken;
  String _userId;

  ProductProvider(this._authToken, this._userId, this._products);

  List<Product> get products {
    return [..._products];
  }

  List<Product> get demandes {
    return _products
        .where((element) => element.type == TypeOfProduct.Demande)
        .toList();
  }

  List<Product> get offres {
    return _products
        .where((element) => element.type == TypeOfProduct.Offre)
        .toList();
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('products');
    databaseReference.once().then((DataSnapshot snapshot) {
      if (snapshot.value == null) return;
      List<Product> products = [];
      snapshot.value.forEach((productId, productData) {
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
            print('Connected to second database and read $_products');
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

  Future<void> addProduct(Product product) async {
    try {
      final url = Uri.parse(
          'https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$_authToken');

      product.creatorIdValue = _userId;
      var response = await http.post(url, body: json.encode(product));

      var newProduct = Product(
        id: json.decode(response.body)['name'],
        description: product.description,
        imageUrl: product.imageUrl,
        type: product.type,
        price: product.price,
        title: product.title,
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      return error;
    }
  }

  Future<void> updateProduct(Product product) async {
    final url = Uri.parse(
        'https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/products/${product.id}.json?auth=$_authToken');

    try {
      product.creatorIdValue = _userId;
      await http.patch(url, body: json.encode(product));
      final index = _products.indexWhere((element) => element.id == product.id);
      _products[index] = product;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      return error;
    }
  }

  void deleteProduct(String id) {
    final url = Uri.parse(
        'https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$_authToken');

    final index = _products.indexWhere((element) => element.id == id);
    var product = _products[index];

    try {
      _products.removeWhere((element) => element.id == id);
      notifyListeners();

      http.delete(url);
    } catch (error) {
      products.insert(index, product);
      notifyListeners();
      return error;
    }
  }

  Product findById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }
}
