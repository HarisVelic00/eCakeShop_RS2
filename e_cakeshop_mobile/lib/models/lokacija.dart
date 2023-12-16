// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'lokacija.g.dart';

@JsonSerializable()
class Lokacija {
  int? lokacijaID;
  String? naziv;
  double? Latitude;
  double? Longitude;

  Lokacija();

  factory Lokacija.fromJson(Map<String, dynamic> json) =>
      _$LokacijaFromJson(json);

  Map<String, dynamic> toJson() => _$LokacijaToJson(this);
}
