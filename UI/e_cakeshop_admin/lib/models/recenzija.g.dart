// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recenzija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recenzija _$RecenzijaFromJson(Map<String, dynamic> json) => Recenzija()
  ..recenzijaID = json['recenzijaID'] as int?
  ..sadrzajRecenzije = json['sadrzajRecenzije'] as String?
  ..ocjena = json['ocjena'] as int?
  ..datumKreiranja = json['datumKreiranja'] == null
      ? null
      : DateTime.parse(json['datumKreiranja'] as String)
  ..korisnikID = json['korisnikID'] as int?
  ..korisnik = json['korisnik'] == null
      ? null
      : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>);

Map<String, dynamic> _$RecenzijaToJson(Recenzija instance) => <String, dynamic>{
      'recenzijaID': instance.recenzijaID,
      'sadrzajRecenzije': instance.sadrzajRecenzije,
      'ocjena': instance.ocjena,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'korisnikID': instance.korisnikID,
      'korisnik': instance.korisnik,
    };
