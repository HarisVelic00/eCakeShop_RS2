import 'package:e_cakeshop_admin/models/narudzbaproizvodi.dart';
import 'package:e_cakeshop_admin/providers/base_provider.dart';

class NarudzbaProizvodiProvider extends BaseProvider<NarudzbaProizvodi> {
  NarudzbaProizvodiProvider() : super("NarudzbaProizvodi");

  @override
  NarudzbaProizvodi fromJson(x) {
    return NarudzbaProizvodi.fromJson(x);
  }
}
