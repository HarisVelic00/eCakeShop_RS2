import 'dart:convert';

import 'package:e_cakeshop/models/proizvod.dart';
import 'package:e_cakeshop/providers/base_provider.dart';
import 'package:e_cakeshop/utils/utils.dart';

class ProizvodProvider extends BaseProvider<Proizvod> {
  ProizvodProvider() : super("Proizvod");

  @override
  fromJson(x) {
    // TODO: implement fromJson
    return Proizvod.fromJson(x);
  }

  Future<List<Proizvod>> Recommend() async {
    var uri =
        Uri.parse("$fullUrl/${Authorization.korisnik!.korisnikID}/recommended");

    Map<String, String> headers = getHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      List<Proizvod> list =
          data.map((x) => fromJson(x)).cast<Proizvod>().toList();
      return list;
    } else {
      throw Exception("Error");
    }
  }
}
