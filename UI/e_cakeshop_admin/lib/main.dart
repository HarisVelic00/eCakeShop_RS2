// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_final_fields, use_build_context_synchronously
import 'package:e_cakeshop_admin/providers/korisnik_provider.dart';
import 'package:e_cakeshop_admin/providers/narudzba_provider.dart';
import 'package:e_cakeshop_admin/providers/novost_provider.dart';
import 'package:e_cakeshop_admin/providers/proizvod_provider.dart';
import 'package:e_cakeshop_admin/providers/recenzija_provider.dart';
import 'package:e_cakeshop_admin/providers/slika_provider.dart';
import 'package:e_cakeshop_admin/screens/home_screen.dart';
import 'package:e_cakeshop_admin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KorisnikProvider()),
        ChangeNotifierProvider(create: (_) => NovostProvider()),
        ChangeNotifierProvider(create: (_) => ProizvodProvider()),
        ChangeNotifierProvider(create: (_) => SlikaProvider()),
        ChangeNotifierProvider(create: (_) => NarudzbaProvider()),
        ChangeNotifierProvider(create: (_) => RecenzijaProvider()),
      ],
      child: MaterialApp(
        home: LoginScreen(),
        onGenerateRoute: (settings) {
          if (settings.name == HomeScreen.routeName) {
            return MaterialPageRoute(builder: ((context) => HomeScreen()));
          } else if (settings.name == LoginScreen.routeName) {
            return MaterialPageRoute(builder: ((context) => LoginScreen()));
          }
          return null;
        },
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  late KorisnikProvider _korisnikProvider;
  final _formKey = GlobalKey<FormState>();
  static const String routeName = "/login";

  void handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        Authorization.Username = _username.text;
        Authorization.Password = _password.text;
        Authorization.korisnik = await _korisnikProvider.Authenticate();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            duration: Duration(seconds: 3),
          ),
        );

        Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName,
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please check your credentials.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _korisnikProvider = Provider.of<KorisnikProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'eCakeShop',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
      ),
      backgroundColor: const Color.fromRGBO(222, 235, 251, 1),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FractionallySizedBox(
                widthFactor: 0.6,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "The username field cannot be empty";
                    } else if (value.length < 3) {
                      return "Username cannot contain fewer than 3 characters";
                    }
                    return null;
                  },
                  controller: _username,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(97, 142, 246, 1)),
                    ),
                  ),
                  cursorColor: const Color.fromRGBO(97, 142, 246, 1),
                  maxLines: 1,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "The password field cannot be empty";
                    } else if (value.length < 4) {
                      return "Password cannot contain fewer than 3 characters";
                    }
                    return null;
                  },
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(97, 142, 246, 1)),
                    ),
                  ),
                  cursorColor: const Color.fromRGBO(97, 142, 246, 1),
                  maxLines: 1,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () => handleLogin(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 48),
                  backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
