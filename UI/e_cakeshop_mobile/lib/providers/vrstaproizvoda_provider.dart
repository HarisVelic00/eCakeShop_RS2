import 'package:e_cakeshop_mobile/models/vrstaproizvoda.dart';
import 'package:e_cakeshop_mobile/providers/base_provider.dart';

class VrstaProizvodaProvider extends BaseProvider<VrstaProizvoda> {
  VrstaProizvodaProvider() : super("VrstaProizvoda");

  @override
  VrstaProizvoda fromJson(x) {
    return VrstaProizvoda.fromJson(x);
  }
}
