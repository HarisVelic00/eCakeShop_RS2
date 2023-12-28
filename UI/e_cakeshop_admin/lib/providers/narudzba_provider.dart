import 'package:e_cakeshop_admin/models/narudzba.dart';
import 'package:e_cakeshop_admin/providers/base_provider.dart';

class NarudzbaProvider extends BaseProvider<Narudzba> {
  NarudzbaProvider() : super("Narudzba");

  @override
  Narudzba fromJson(x) {
    return Narudzba.fromJson(x);
  }
}
