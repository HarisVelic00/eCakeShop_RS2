// ignore_for_file: unnecessary_cast, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:e_cakeshop_mobile/models/korisnik.dart';
import 'package:e_cakeshop_mobile/providers/base_provider.dart';

class KorisnikProvider extends BaseProvider<Korisnik> {
  KorisnikProvider() : super("Korisnik");
  static const String _baseUrl = "http://10.0.2.2:7166/";

  @override
  Korisnik fromJson(x) {
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

  Future<Korisnik> updateMobile(int id, Map<String, dynamic> request) async {
    var baseUrl = Uri.parse(_baseUrl);
    var endpoint = "Korisnik/$id/UpdateMobile";

    var uri = baseUrl.replace(path: baseUrl.path + endpoint);

    var headers = getHeaders();
    var jsonRequest = jsonEncode(request);

    try {
      var response = await http!.put(uri, headers: headers, body: jsonRequest);

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (isValidResponseCode(response)) {
        var data = jsonDecode(response.body);
        Korisnik updatedUser = fromJson(data) as Korisnik;
        return updatedUser;
      } else {
        throw Exception("Failed to update mobile: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to update mobile: $e");
    }
  }
}
