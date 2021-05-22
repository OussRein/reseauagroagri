import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'annonce.g.dart';

enum TypeOfAnnonce {
  @JsonValue("Demande") Demande,
  @JsonValue("Offre") Offre,
}

@JsonSerializable()
class Annonce with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  TypeOfAnnonce type;
  String creatorId;

  Annonce(
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
 
  factory Annonce.fromJson(Map<String, dynamic> json) => _$AnnonceFromJson(json);

  Map<String, dynamic> toJson() => _$AnnonceToJson(this);
}
