// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vrstaproizvoda.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VrstaProizvoda _$VrstaProizvodaFromJson(Map<String, dynamic> json) =>
    VrstaProizvoda()
      ..vrstaproizvodaID = json['vrstaproizvodaID'] as int?
      ..naziv = json['naziv'] as String?
      ..opis = json['opis'] as String?;

Map<String, dynamic> _$VrstaProizvodaToJson(VrstaProizvoda instance) =>
    <String, dynamic>{
      'vrstaproizvodaID': instance.vrstaproizvodaID,
      'naziv': instance.naziv,
      'opis': instance.opis,
    };
