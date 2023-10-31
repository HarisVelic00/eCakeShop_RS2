import 'package:e_cakeshop/models/korisnik.dart';
import 'package:e_cakeshop/models/narudzbaproizvodi.dart';

class Narudzba {
  int? narudzbaID;
  String? brojNarudzbe;
  int? korisnikID;
  DateTime? datumNarudzbe;
  String? narudzbaProizvodi;
  double? ukupnaCijena;
  bool? isCanceled;
  bool? isShipped;
  Korisnik? korisnik;
  List<NarudzbaProizvodi>? narudzbaProizvodis;

  Narudzba();
}
