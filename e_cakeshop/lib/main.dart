import 'package:e_cakeshop/desktop/ui/home_screen.dart';
// ignore: unused_import
import 'package:e_cakeshop/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
