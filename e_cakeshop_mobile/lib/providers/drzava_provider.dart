import 'package:e_cakeshop_mobile/providers/base_provider.dart';

import '../models/drzava.dart';

class DrzavaProvider extends BaseProvider<Drzava> {
  DrzavaProvider() : super("Drzava");

  @override
  Drzava fromJson(x) {
    return Drzava.fromJson(x);
  }
}
