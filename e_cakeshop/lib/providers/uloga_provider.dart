import 'package:e_cakeshop/providers/base_provider.dart';
import '../models/uloga.dart';

class UlogaProvider extends BaseProvider<Uloga> {
  UlogaProvider() : super("Uloga");

  @override
  Uloga fromJson(x) {
    return Uloga.fromJson(x);
  }
}
