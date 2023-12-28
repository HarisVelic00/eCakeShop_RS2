// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lokacija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lokacija _$LokacijaFromJson(Map<String, dynamic> json) => Lokacija()
  ..lokacijaID = json['lokacijaID'] as int?
  ..naziv = json['naziv'] as String?
  ..Latitude = (json['Latitude'] as num?)?.toDouble()
  ..Longitude = (json['Longitude'] as num?)?.toDouble();

Map<String, dynamic> _$LokacijaToJson(Lokacija instance) => <String, dynamic>{
      'lokacijaID': instance.lokacijaID,
      'naziv': instance.naziv,
      'Latitude': instance.Latitude,
      'Longitude': instance.Longitude,
    };
