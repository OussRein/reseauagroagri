import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePick;
  final String annonceImage;
  UserImagePicker(this.imagePick, this.annonceImage);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _image;

  final picker = ImagePicker();

  /*Future _getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    widget.imagePick(_image);
  }*/

  Future _imgFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    widget.imagePick(_image);
  }

  Future _imgFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    widget.imagePick(_image);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget showWidget() {
    if (_image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.file(
          _image,
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      );
    } else {
      if(widget.annonceImage != null){
        return ClipRRect(
        borderRadius: BorderRadius.circular(55),
        child: Image.network(
          widget.annonceImage,
          width: 100,
          height: 100,
          fit: BoxFit.fill,
        ),
      );
      }else  return Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(50)),
        width: 100,
        height: 100,
        child: Icon(
          Icons.camera_alt,
          color: Colors.grey[800],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Center(
        child: GestureDetector(
          onTap: () {
            _showPicker(context);
          },
          child: CircleAvatar(
            radius: 55,
            backgroundColor: Theme.of(context).primaryColorLight,
            child: showWidget(),
          ),
        ),
      ),

      /*Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: _image != null ? FileImage(_image) : null,
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: _getImage,
              icon: Icon(Icons.image),
              label: Text('Ajouter une image'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColorDark,
                ),
              ),
            ),

            /*TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                onSaved: (value) {
                                  _product = Product(
                                    id: _product.id,
                                    description: _product.description,
                                    imageUrl: value,
                                    type: _product.type,
                                    price: _product.price,
                                    title: _product.title,
                                  );
                                },
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Please put an image!';
                                  if (!value.startsWith("http"))
                                    return 'Enter a valid url!';
                                  return null;
                                },
                              ),*/
          ),
        ],*/
    );
  }
}
