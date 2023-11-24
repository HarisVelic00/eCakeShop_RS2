// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Novost _$NovostFromJson(Map<String, dynamic> json) => Novost(
      novostID: json['novostID'] as int?,
      naslov: json['naslov'] as String?,
      sadrzaj: json['sadrzaj'] as String?,
      thumbnail: json['thumbnail'] as String?,
      opis: json['opis'] as String?,
      datumKreiranja: json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      korisnikID: json['korisnikID'] as int?,
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NovostToJson(Novost instance) => <String, dynamic>{
      'novostID': instance.novostID,
      'naslov': instance.naslov,
      'sadrzaj': instance.sadrzaj,
      'thumbnail': instance.thumbnail,
      'opis': instance.opis,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'korisnikID': instance.korisnikID,
      'korisnik': instance.korisnik,
    };
