import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/korisnik.dart';

class Authorization {
  static String? Username;
  static String? Password;
  static Korisnik? korisnik;
}

Image imageFromBase64String(String base64String) {
  return Image.memory(Uint8List.fromList(base64Decode(base64String)));
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}

String formatDate(DateTime date) => DateFormat("dd/MM/yyyy").format(date);

String formatNumber(dynamic dynamic) {
  var f = NumberFormat('###.00');
  if (dynamic == null) {
    return "";
  }

  return f.format(dynamic);
}
