import 'package:e_cakeshop_admin/models/uloga.dart';
import 'package:e_cakeshop_admin/providers/base_provider.dart';

class UlogaProvider extends BaseProvider<Uloga> {
  UlogaProvider() : super("Uloga");

  @override
  Uloga fromJson(x) {
    return Uloga.fromJson(x);
  }
}
