import 'package:json_annotation/json_annotation.dart';
part 'uplata.g.dart';

@JsonSerializable()
class Uplata {
  int? uplataID;
  double? iznos;
  DateTime? datumTransakcije;
  String? brojTransakcije;
  int? korisnikID;

  Uplata({
    this.uplataID,
    this.iznos,
    this.datumTransakcije,
    this.brojTransakcije,
    this.korisnikID,
  });

  factory Uplata.fromJson(Map<String, dynamic> json) => _$UplataFromJson(json);

  Map<String, dynamic> toJson() => _$UplataToJson(this);
}
