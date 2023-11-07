import 'package:e_cakeshop/models/recenzija.dart';
import 'package:e_cakeshop/providers/base_provider.dart';

class RecenzijaProvider extends BaseProvider<Recenzija> {
  RecenzijaProvider() : super("Recenzija");

  @override
  fromJson(x) {
    return Recenzija.fromJson(x);
  }
}
