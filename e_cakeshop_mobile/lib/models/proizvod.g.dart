// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proizvod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Proizvod _$ProizvodFromJson(Map<String, dynamic> json) => Proizvod()
  ..proizvodID = json['proizvodID'] as int?
  ..naziv = json['naziv'] as String?
  ..sifra = json['sifra'] as String?
  ..cijena = (json['cijena'] as num?)?.toDouble()
  ..slika = json['slika'] as String?
  ..opis = json['opis'] as String?
  ..vrstaProizvodaID = json['vrstaProizvodaID'] as int?
  ..vrstaProizvoda = json['vrstaProizvoda'] == null
      ? null
      : VrstaProizvoda.fromJson(json['vrstaProizvoda'] as Map<String, dynamic>);

Map<String, dynamic> _$ProizvodToJson(Proizvod instance) => <String, dynamic>{
      'proizvodID': instance.proizvodID,
      'naziv': instance.naziv,
      'sifra': instance.sifra,
      'cijena': instance.cijena,
      'slika': instance.slika,
      'opis': instance.opis,
      'vrstaProizvodaID': instance.vrstaProizvodaID,
      'vrstaProizvoda': instance.vrstaProizvoda,
    };
