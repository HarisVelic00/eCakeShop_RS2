import 'package:e_cakeshop/providers/base_provider.dart';

import '../models/narudzba.dart';

class NarudzbaProvider extends BaseProvider<Narudzba> {
  NarudzbaProvider() : super("Narudzba");

  @override
  Narudzba fromJson(x) {
    return Narudzba.fromJson(x);
  }
}
