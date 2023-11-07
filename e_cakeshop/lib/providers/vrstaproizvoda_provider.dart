import 'package:e_cakeshop/models/vrstaproizvoda.dart';
import 'package:e_cakeshop/providers/base_provider.dart';

class VrstaProizvodaProvider extends BaseProvider<VrstaProizvoda> {
  VrstaProizvodaProvider() : super("VrstaProizvoda");

  @override
  fromJson(x) {
    return VrstaProizvoda.fromJson(x);
  }
}
