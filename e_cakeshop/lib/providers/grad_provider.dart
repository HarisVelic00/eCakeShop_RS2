import 'package:e_cakeshop/models/grad.dart';
import 'package:e_cakeshop/providers/base_provider.dart';

class GradProvider extends BaseProvider<Grad> {
  GradProvider() : super("Grad");

  @override
  Grad fromJson(x) {
    return Grad.fromJson(x);
  }
}
