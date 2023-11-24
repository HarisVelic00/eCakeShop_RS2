import 'package:e_cakeshop_mobile/models/slika.dart';
import 'package:e_cakeshop_mobile/providers/base_provider.dart';

class SlikaProvider extends BaseProvider<Slika> {
  SlikaProvider() : super("Slika");

  @override
  Slika fromJson(x) {
    return Slika.fromJson(x);
  }
}
