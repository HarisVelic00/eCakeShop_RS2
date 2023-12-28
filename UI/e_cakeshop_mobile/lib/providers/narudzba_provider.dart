import 'package:e_cakeshop_mobile/models/narudzba.dart';
import 'package:e_cakeshop_mobile/providers/base_provider.dart';

class NarudzbaProvider extends BaseProvider<Narudzba> {
  NarudzbaProvider() : super("Narudzba");

  @override
  Narudzba fromJson(x) {
    return Narudzba.fromJson(x);
  }
}
