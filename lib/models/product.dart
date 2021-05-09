import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

enum TypeOfProduct {
  @JsonValue("Demande") Demande,
  @JsonValue("Offre") Offre,
}

@JsonSerializable()
class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  TypeOfProduct type;
  String creatorId;

  Product(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.imageUrl,
      this.creatorId,
      this.type});

  set creatorIdValue(String newCreatorId){
    this.creatorId = newCreatorId;
  }
 
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
