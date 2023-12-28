import 'package:e_cakeshop_admin/models/grad.dart';
import 'package:e_cakeshop_admin/providers/base_provider.dart';

class GradProvider extends BaseProvider<Grad> {
  GradProvider() : super("Grad");

  @override
  Grad fromJson(x) {
    return Grad.fromJson(x);
  }
}
