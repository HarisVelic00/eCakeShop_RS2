import 'package:e_cakeshop_admin/models/uplata.dart';
import 'package:e_cakeshop_admin/providers/base_provider.dart';

class UplataProvider extends BaseProvider<Uplata> {
  UplataProvider() : super("Uplata");

  @override
  Uplata fromJson(x) {
    return Uplata.fromJson(x);
  }
}
