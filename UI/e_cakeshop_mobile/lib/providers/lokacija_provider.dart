import 'package:e_cakeshop_mobile/models/lokacija.dart';
import 'package:e_cakeshop_mobile/providers/base_provider.dart';

class DrzavaProvider extends BaseProvider<Lokacija> {
  DrzavaProvider() : super("Lokacija");

  @override
  Lokacija fromJson(x) {
    return Lokacija.fromJson(x);
  }
}
