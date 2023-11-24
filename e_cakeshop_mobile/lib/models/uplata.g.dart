// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uplata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Uplata _$UplataFromJson(Map<String, dynamic> json) => Uplata(
      uplataID: json['uplataID'] as int?,
      iznos: (json['iznos'] as num?)?.toDouble(),
      datumTransakcije: json['datumTransakcije'] == null
          ? null
          : DateTime.parse(json['datumTransakcije'] as String),
      brojTransakcije: json['brojTransakcije'] as String?,
      korisnikID: json['korisnikID'] as int?,
    );

Map<String, dynamic> _$UplataToJson(Uplata instance) => <String, dynamic>{
      'uplataID': instance.uplataID,
      'iznos': instance.iznos,
      'datumTransakcije': instance.datumTransakcije?.toIso8601String(),
      'brojTransakcije': instance.brojTransakcije,
      'korisnikID': instance.korisnikID,
    };
