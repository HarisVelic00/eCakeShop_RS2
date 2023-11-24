import 'dart:convert';
import 'package:e_cakeshop_mobile/models/korisnik.dart';
import 'package:e_cakeshop_mobile/providers/base_provider.dart';

class KorisnikProvider extends BaseProvider<Korisnik> {
  KorisnikProvider() : super("Korisnik");

  @override
  Korisnik fromJson(x) {
    // TODO: implement fromJson
    return Korisnik.fromJson(x);
  }

  Future<Korisnik> Authenticate() async {
    var url = "$fullUrl/Authenticate";
    var uri = Uri.parse(url);

    var headers = getHeaders();
    var response = await http!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      Korisnik user = fromJson(data) as Korisnik;
      return user;
    } else {
      throw Exception("Wrong username or password");
    }
  }
}
