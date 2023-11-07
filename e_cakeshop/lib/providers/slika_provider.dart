import 'package:e_cakeshop/models/slika.dart';
import 'package:e_cakeshop/providers/base_provider.dart';

class SlikaProvider extends BaseProvider<Slika> {
  SlikaProvider() : super("Slika");

  @override
  Slika fromJson(x) {
    return Slika.fromJson(x);
  }
}
