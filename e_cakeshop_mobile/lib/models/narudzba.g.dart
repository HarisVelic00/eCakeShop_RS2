// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Narudzba _$NarudzbaFromJson(Map<String, dynamic> json) => Narudzba(
      narudzbaID: json['narudzbaID'] as int?,
      brojNarudzbe: json['brojNarudzbe'] as String?,
      korisnikID: json['korisnikID'] as int?,
      datumNarudzbe: json['datumNarudzbe'] == null
          ? null
          : DateTime.parse(json['datumNarudzbe'] as String),
      narudzbaProizvodi: json['narudzbaProizvodi'] as String?,
      ukupnaCijena: (json['ukupnaCijena'] as num?)?.toDouble(),
      isCanceled: json['isCanceled'] as bool?,
      isShipped: json['isShipped'] as bool?,
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      narudzbaProizvodis: (json['narudzbaProizvodis'] as List<dynamic>?)
          ?.map((e) => NarudzbaProizvodi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NarudzbaToJson(Narudzba instance) => <String, dynamic>{
      'narudzbaID': instance.narudzbaID,
      'brojNarudzbe': instance.brojNarudzbe,
      'korisnikID': instance.korisnikID,
      'datumNarudzbe': instance.datumNarudzbe?.toIso8601String(),
      'narudzbaProizvodi': instance.narudzbaProizvodi,
      'ukupnaCijena': instance.ukupnaCijena,
      'isCanceled': instance.isCanceled,
      'isShipped': instance.isShipped,
      'korisnik': instance.korisnik,
      'narudzbaProizvodis': instance.narudzbaProizvodis,
    };
