import 'package:e_cakeshop/providers/base_provider.dart';

import '../models/novost.dart';

class NovostProvider extends BaseProvider<Novost> {
  NovostProvider() : super("Novost");

  @override
  fromJson(x) {
    // TODO: implement fromJson
    return Novost.fromJson(x);
  }
}
