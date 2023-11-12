import 'package:e_cakeshop/models/vrstaproizvoda.dart';
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

  Proizvod({
    this.proizvodID,
    this.naziv,
    this.sifra,
    this.cijena,
    this.slika,
    this.opis,
    this.vrstaProizvodaID,
    this.vrstaProizvoda,
  });

  factory Proizvod.fromJson(Map<String, dynamic> json) =>
      _$ProizvodFromJson(json);

  Map<String, dynamic> toJson() => _$ProizvodToJson(this);
}
