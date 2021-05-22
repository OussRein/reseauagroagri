import 'dart:io';

import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reseau_agroagri_app/pickers/upload_image_picker.dart';
import '../models/annonce.dart';
import '../providers/annoncess_provider.dart';
import 'package:path/path.dart' as path;

class EditAnnoncePage extends StatefulWidget {
  static const String ROUTE = "/edit-product-page";
  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditAnnoncePage> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  String _annonceImage;


  Annonce _product = Annonce(
    id: null,
    description: '',
    imageUrl: '',
    price: 0.0,
    title: '',
    type: TypeOfAnnonce.Offre,
  );

  var _initValues = {
    'description': '',
    'imageUrl': '',
    'price': '',
    'title': '',
    'type': TypeOfAnnonce.Offre,
  };

  bool _isInit = true;
  bool _isLoading = false;
  bool _newUrl = false;

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
    _newUrl = true;
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null && productId.isNotEmpty) {
        _product = Provider.of<AnnoncesProvider>(context).findById(productId);
        _initValues = {
          'description': _product.description,
          'imageUrl': _product.imageUrl,
          'price': _product.price.toString(),
          'title': _product.title,
          'type': _product.type,
        };
        _annonceImage = _product.imageUrl;
        _imageUrlController.text = _product.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  String url;

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = path.basename(_userImageFile.path);
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    final uploadTask = await firebaseStorageRef.putFile(_userImageFile);
    final taskSnapshot = uploadTask;
    await taskSnapshot.ref.getDownloadURL().then(
      (value) {
        print("Done: $value");
        url = value;
      },
    );
  }

  void _saveForm(BuildContext context) async {
    var isValid = _form.currentState.validate();
    if (_userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ajouter une image!'),
        ),
      );
      return;
    }
    if (!isValid) return;
    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_newUrl) {
      uploadImageToFirebase(context).then((_) {
        _product = Annonce(
          id: _product.id,
          description: _product.description,
          imageUrl: url,
          type: _product.type,
          price: _product.price,
          title: _product.title,
          creatorId: FirebaseAuth.instance.currentUser.uid,
        );
        print(url);
        if (_product.id != null) {
          Provider.of<AnnoncesProvider>(context, listen: false)
              .updateAnnonce(_product)
              .catchError((error) {
            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text("An error occured!"),
                      content: Text("Problem in sending data!"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text("Ok!")),
                      ],
                    ));
          }).then((value) {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pop();
          });
        } else {
          Provider.of<AnnoncesProvider>(context, listen: false)
              .addAnnonce(_product)
              .catchError((error) {
            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text("An error occured!"),
                      content: Text("Problem in sending data!"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text("Ok!")),
                      ],
                    ));
          }).then((value) {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pop();
          });
        }
      });
    }else {
      if (_product.id != null) {
          Provider.of<AnnoncesProvider>(context, listen: false)
              .updateAnnonce(_product)
              .catchError((error) {
            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text("An error occured!"),
                      content: Text("Problem in sending data!"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text("Ok!")),
                      ],
                    ));
          }).then((value) {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pop();
          });
        } else {
          Provider.of<AnnoncesProvider>(context, listen: false)
              .addAnnonce(_product)
              .catchError((error) {
            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text("An error occured!"),
                      content: Text("Problem in sending data!"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text("Ok!")),
                      ],
                    ));
          }).then((value) {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pop();
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(context),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(20.0,0,20.0,0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      UserImagePicker(_pickedImage,_annonceImage),
                      SizedBox(height: 20,),
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) return 'Please put a title';
                          return null;
                        },
                        onSaved: (value) {
                          _product = Annonce(
                            id: _product.id,
                            description: _product.description,
                            imageUrl: _product.imageUrl,
                            type: _product.type,
                            price: _product.price,
                            title: value,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) return 'Please put a price!';
                          if (double.tryParse(value) == null)
                            return 'Please a valid price!';
                          if (double.parse(value) <= 0)
                            return 'The price must be greater then 0!';
                          return null;
                        },
                        onSaved: (value) {
                          _product = Annonce(
                            id: _product.id,
                            description: _product.description,
                            imageUrl: _product.imageUrl,
                            type: _product.type,
                            price: double.parse(value),
                            title: _product.title,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: "Description"),
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          _product = Annonce(
                            id: _product.id,
                            description: value,
                            imageUrl: _product.imageUrl,
                            type: _product.type,
                            price: _product.price,
                            title: _product.title,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) return 'Please put a description!';
                          if (value.length < 10)
                            return 'Description is too short!';
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Type: ",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(color: Colors.black),
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 10),
                            CustomRadioButton(
                              enableShape: true,
                              defaultSelected: TypeOfAnnonce.Offre,
                              width: 150,
                              elevation: 0,
                              horizontal: true,
                              absoluteZeroSpacing: true,
                              unSelectedColor: Theme.of(context).canvasColor,
                              buttonLables: [
                                'Offre',
                                'Demande',
                              ],
                              buttonValues: [
                                TypeOfAnnonce.Offre,
                                TypeOfAnnonce.Demande,
                              ],
                              buttonTextStyle: ButtonTextStyle(
                                selectedColor: Colors.white,
                                unSelectedColor: Colors.black,
                                textStyle: TextStyle(fontSize: 16),
                              ),
                              radioButtonValue: (value) {
                                setState(() {
                                  _product = Annonce(
                                    id: _product.id,
                                    description: _product.description,
                                    imageUrl: _product.imageUrl,
                                    type: value,
                                    price: _product.price,
                                    title: _product.title,
                                  );
                                });
                              },
                              selectedColor: Theme.of(context).primaryColorDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: Container(
        height: 60,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100))),
        margin: EdgeInsets.all(20),
        child: InkWell(
          onTap: () => _saveForm(context),
          child: Ink(
            color: Colors.green,
            child: Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.save,
                    ),
                  ),
                  Text(
                    "Sauvgarder",
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
