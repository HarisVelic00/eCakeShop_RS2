// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnik _$KorisnikFromJson(Map<String, dynamic> json) => Korisnik()
  ..korisnikID = json['korisnikID'] as int?
  ..ime = json['ime'] as String?
  ..prezime = json['prezime'] as String?
  ..korisnickoIme = json['korisnickoIme'] as String?
  ..datumRodjenja = json['datumRodjenja'] == null
      ? null
      : DateTime.parse(json['datumRodjenja'] as String)
  ..email = json['email'] as String?
  ..telefon = json['telefon'] as String?
  ..lokacija = json['lokacija'] as String?
  ..gradID = json['gradID'] as int?
  ..drzavaID = json['drzavaID'] as int?
  ..grad = json['grad'] == null
      ? null
      : Grad.fromJson(json['grad'] as Map<String, dynamic>)
  ..drzava = json['drzava'] == null
      ? null
      : Drzava.fromJson(json['drzava'] as Map<String, dynamic>);

Map<String, dynamic> _$KorisnikToJson(Korisnik instance) => <String, dynamic>{
      'korisnikID': instance.korisnikID,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'korisnickoIme': instance.korisnickoIme,
      'datumRodjenja': instance.datumRodjenja?.toIso8601String(),
      'email': instance.email,
      'telefon': instance.telefon,
      'lokacija': instance.lokacija,
      'gradID': instance.gradID,
      'drzavaID': instance.drzavaID,
      'grad': instance.grad,
      'drzava': instance.drzava,
    };
