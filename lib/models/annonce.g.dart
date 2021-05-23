// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annonce.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Annonce _$AnnonceFromJson(Map<String, dynamic> json) {
  return Annonce(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    price: (json['price'] as num)?.toDouble(),
    imageUrl: json['imageUrl'] as String,
    reference: json['reference'] as num,
    creatorId: json['creatorId'] as String,
    dateCreation: DateTime.parse(json['dateCreation']),
    type: _$enumDecodeNullable(_$TypeOfAnnonceEnumMap, json['type']),
  );
}

Map<String, dynamic> _$AnnonceToJson(Annonce instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'reference': instance.reference,
      'creatorId': instance.creatorId,
      'dateCreation' : instance.dateCreation.toIso8601String(),
      'type': _$TypeOfAnnonceEnumMap[instance.type],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$TypeOfAnnonceEnumMap = {
  TypeOfAnnonce.Demande: 'Demande',
  TypeOfAnnonce.Offre: 'Offre',
};
