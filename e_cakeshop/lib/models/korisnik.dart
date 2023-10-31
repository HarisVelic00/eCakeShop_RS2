import 'package:e_cakeshop/models/drzava.dart';
import 'package:e_cakeshop/models/grad.dart';

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

  Korisnik();
}
