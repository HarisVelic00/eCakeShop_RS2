// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uloga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Uloga _$UlogaFromJson(Map<String, dynamic> json) => Uloga()
  ..ulogaID = json['ulogaID'] as int?
  ..naziv = json['naziv'] as String?
  ..opis = json['opis'] as String?;

Map<String, dynamic> _$UlogaToJson(Uloga instance) => <String, dynamic>{
      'ulogaID': instance.ulogaID,
      'naziv': instance.naziv,
      'opis': instance.opis,
    };
