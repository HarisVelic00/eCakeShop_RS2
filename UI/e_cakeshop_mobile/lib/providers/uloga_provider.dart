import 'package:e_cakeshop_mobile/models/uloga.dart';
import 'package:e_cakeshop_mobile/providers/base_provider.dart';

class UlogaProvider extends BaseProvider<Uloga> {
  UlogaProvider() : super("Uloga");

  @override
  Uloga fromJson(x) {
    return Uloga.fromJson(x);
  }
}
