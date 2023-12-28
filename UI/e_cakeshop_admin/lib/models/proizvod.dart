import 'package:e_cakeshop_admin/models/vrstaproizvoda.dart';
import 'package:json_annotation/json_annotation.dart';
part 'proizvod.g.dart';

@JsonSerializable()
class Proizvod {
  int? proizvodID;
  String? naziv;
  String? sifra;
  double? cijena;
  String? slika;
  String? opis;
  int? vrstaProizvodaID;
  VrstaProizvoda? vrstaProizvoda;

  Proizvod();

  factory Proizvod.fromJson(Map<String, dynamic> json) =>
      _$ProizvodFromJson(json);

  Map<String, dynamic> toJson() => _$ProizvodToJson(this);
}
