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

  Annonce _annonce = Annonce(
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
    'reference': '',
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
        _annonce = Provider.of<AnnoncesProvider>(context).findById(productId);
        _initValues = {
          'description': _annonce.description,
          'imageUrl': _annonce.imageUrl,
          'price': _annonce.price.toString(),
          'title': _annonce.title,
          'type': _annonce.type,
          'reference': _annonce.reference,
          'dateCreation': _annonce.dateCreation,
          'creatorId': _annonce.creatorId,
          'id': _annonce.id,
        };
        _annonceImage = _annonce.imageUrl;
        _imageUrlController.text = _annonce.imageUrl;
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
    if (_userImageFile == null && _annonce.id == null) {
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
        _annonce = Annonce(
          id: _annonce.id,
          description: _annonce.description,
          imageUrl: url,
          type: _annonce.type,
          price: _annonce.price,
          title: _annonce.title,
          reference: _annonce.reference,
          creatorId: FirebaseAuth.instance.currentUser.uid,
          dateCreation: DateTime.now(),
        );
        print(url);
        if (_annonce.id != null) {
          Provider.of<AnnoncesProvider>(context, listen: false)
              .updateAnnonce(_annonce)
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
              .addAnnonce(_annonce)
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
    } else {
      if (_annonce.id != null) {
        Provider.of<AnnoncesProvider>(context, listen: false)
            .updateAnnonce(_annonce)
            .catchError((error) {
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text("An error occured!"),
                    content: Text("Problem dans l'envoi des données!"),
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
            .addAnnonce(_annonce)
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
        title: Text(
          _annonce.id == null ? "Deposer une annonce" : "Edit annonce",
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
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
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      UserImagePicker(_pickedImage, _annonceImage),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) return 'Please put a title';
                          return null;
                        },
                        onSaved: (value) {
                          _annonce = Annonce(
                            id: _annonce.id,
                            description: _annonce.description,
                            imageUrl: _annonce.imageUrl,
                            type: _annonce.type,
                            price: _annonce.price,
                            reference: _annonce.reference,
                            title: value,
                            dateCreation: _annonce.dateCreation,
                            creatorId: _annonce.creatorId,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: "Prix"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) return 'Ajouter un prix!';
                          if (double.tryParse(value) == null)
                            return 'Ajouter une valeur de prix valide!!';
                          if (double.parse(value) <= 0)
                            return 'Le prix doit etre supperieur a 0!';
                          return null;
                        },
                        onSaved: (value) {
                          _annonce = Annonce(
                            id: _annonce.id,
                            description: _annonce.description,
                            imageUrl: _annonce.imageUrl,
                            reference: _annonce.reference,
                            type: _annonce.type,
                            price: double.parse(value),
                            title: _annonce.title,
                            dateCreation: _annonce.dateCreation,
                            creatorId: _annonce.creatorId,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['reference'].toString(),
                        decoration: InputDecoration(labelText: "Reference"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) return 'Ajouter une Reference!';
                          if (double.parse(value) <= 0)
                            return 'La valeur de reference doit etre supperieur a 0!';
                          return null;
                        },
                        onSaved: (value) {
                          _annonce = Annonce(
                            id: _annonce.id,
                            description: _annonce.description,
                            imageUrl: _annonce.imageUrl,
                            type: _annonce.type,
                            price: _annonce.price,
                            reference: int.parse(value),
                            title: _annonce.title,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: "Description"),
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          _annonce = Annonce(
                            id: _annonce.id,
                            description: value,
                            imageUrl: _annonce.imageUrl,
                            type: _annonce.type,
                            price: _annonce.price,
                            reference: _annonce.reference,
                            title: _annonce.title,
                            dateCreation: _annonce.dateCreation,
                            creatorId: _annonce.creatorId,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) return 'Ajouter une description!';
                          if (value.length < 10)
                            return 'La description est trop courte!';
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
                                  _annonce = Annonce(
                                    id: _annonce.id,
                                    description: _annonce.description,
                                    imageUrl: _annonce.imageUrl,
                                    type: value,
                                    price: _annonce.price,
                                    title: _annonce.title,
                                    reference: _annonce.reference,
                                    dateCreation: _annonce.dateCreation,
                                    creatorId: _annonce.creatorId,
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
