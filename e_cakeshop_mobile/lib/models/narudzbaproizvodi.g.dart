// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzbaproizvodi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NarudzbaProizvodi _$NarudzbaProizvodiFromJson(Map<String, dynamic> json) =>
    NarudzbaProizvodi()
      ..narudzbaProizvodiID = json['narudzbaProizvodiID'] as int?
      ..proizvodID = json['proizvodID'] as int?
      ..narudzbaID = json['narudzbaID'] as int?
      ..kolicina = json['kolicina'] as int?
      ..proizvod = json['proizvod'] == null
          ? null
          : Proizvod.fromJson(json['proizvod'] as Map<String, dynamic>);

Map<String, dynamic> _$NarudzbaProizvodiToJson(NarudzbaProizvodi instance) =>
    <String, dynamic>{
      'narudzbaProizvodiID': instance.narudzbaProizvodiID,
      'proizvodID': instance.proizvodID,
      'narudzbaID': instance.narudzbaID,
      'kolicina': instance.kolicina,
      'proizvod': instance.proizvod,
    };
