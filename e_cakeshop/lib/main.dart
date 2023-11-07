import 'package:e_cakeshop/desktop/ui/home_screen.dart';
import 'package:e_cakeshop/login_screen.dart';
import 'package:e_cakeshop/providers/korisnik_provider.dart';
import 'package:e_cakeshop/providers/narudzba_provider.dart';
import 'package:e_cakeshop/providers/novost_provider.dart';
import 'package:e_cakeshop/providers/proizvod_provider.dart';
import 'package:e_cakeshop/providers/slika_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KorisnikProvider()),
        ChangeNotifierProvider(create: (_) => ProizvodProvider()),
        ChangeNotifierProvider(create: (_) => NovostProvider()),
        ChangeNotifierProvider(create: (_) => SlikaProvider()),
        ChangeNotifierProvider(create: (_) => NarudzbaProvider()),
      ],
      child: MaterialApp(
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
