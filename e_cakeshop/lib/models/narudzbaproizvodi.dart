import 'package:e_cakeshop/models/proizvod.dart';
import 'package:json_annotation/json_annotation.dart';
part 'narudzbaproizvodi.g.dart';

@JsonSerializable()
class NarudzbaProizvodi {
  int? narudzbaProizvodiID;
  int? proizvodID;
  int? narudzbaID;
  int? kolicina;
  Proizvod? proizvod;

  NarudzbaProizvodi();

  factory NarudzbaProizvodi.fromJson(Map<String, dynamic> json) =>
      _$NarudzbaProizvodiFromJson(json);

  Map<String, dynamic> toJson() => _$NarudzbaProizvodiToJson(this);
}
