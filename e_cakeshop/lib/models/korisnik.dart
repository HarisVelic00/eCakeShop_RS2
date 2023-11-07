import 'package:e_cakeshop/models/drzava.dart';
import 'package:e_cakeshop/models/grad.dart';
import 'package:json_annotation/json_annotation.dart';
part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik {
  int? korisnikID;
  String? ime;
  String? prezime;
  String? korisnickoIme;
  DateTime? datumRodjenja;
  String? email;
  String? telefon;
  String? lokacija;
  int? gradID;
  int? drzavaID;
  Grad? grad;
  Drzava? drzava;

  Korisnik() {}

  factory Korisnik.fromJson(Map<String, dynamic> json) =>
      _$KorisnikFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
