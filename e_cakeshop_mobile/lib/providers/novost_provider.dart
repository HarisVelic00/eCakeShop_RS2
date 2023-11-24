import 'package:e_cakeshop_mobile/models/novost.dart';
import 'package:e_cakeshop_mobile/providers/base_provider.dart';

class NovostProvider extends BaseProvider<Novost> {
  NovostProvider() : super("Novost");

  @override
  fromJson(x) {
    // TODO: implement fromJson
    return Novost.fromJson(x);
  }
}
