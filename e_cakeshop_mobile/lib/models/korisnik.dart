
import 'package:e_cakeshop_mobile/models/drzava.dart';
import 'package:e_cakeshop_mobile/models/grad.dart';
import 'package:e_cakeshop_mobile/models/uloga.dart';
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
  String? lozinka;
  Uloga? uloga;

  Korisnik({
    this.ime,
    this.prezime,
    this.korisnickoIme,
    this.datumRodjenja,
    this.email,
    this.telefon,
    this.lokacija,
    this.gradID,
    this.drzavaID,
    this.grad,
    this.drzava,
    this.lozinka,
    this.uloga,
  });

  factory Korisnik.fromJson(Map<String, dynamic> json) =>
      _$KorisnikFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
