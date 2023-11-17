import 'package:e_cakeshop/desktop/ui/home_screen.dart';
import 'package:e_cakeshop/providers/korisnik_provider.dart';
import 'package:e_cakeshop/providers/narudzba_provider.dart';
import 'package:e_cakeshop/providers/novost_provider.dart';
import 'package:e_cakeshop/providers/proizvod_provider.dart';
import 'package:e_cakeshop/providers/slika_provider.dart';
import 'package:e_cakeshop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MainApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KorisnikProvider()),
        ChangeNotifierProvider(create: (_) => NovostProvider()),
        ChangeNotifierProvider(create: (_) => ProizvodProvider()),
        ChangeNotifierProvider(create: (_) => SlikaProvider()),
        ChangeNotifierProvider(create: (_) => NarudzbaProvider())
      ],
      child: MaterialApp(
        home: LoginScreen(),
        onGenerateRoute: (settings) {
          if (settings.name == HomeScreen.routeName) {
            return MaterialPageRoute(builder: ((context) => HomeScreen()));
          } else if (settings.name == LoginScreen.routeName) {
            return MaterialPageRoute(builder: ((context) => LoginScreen()));
          }
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
    final double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 600 ? 24 : 16;

    if (fontSize > 24) {
      fontSize = 24;
    } else if (fontSize < 16) {
      fontSize = 16;
    }

    final double textFieldWidth = screenWidth > 600 ? 400 : screenWidth - 40;

    return Scaffold(
      appBar: AppBar(
        title: const Text('eCakeShop'),
        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
      ),
      backgroundColor: const Color.fromRGBO(222, 235, 251, 1),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: textFieldWidth,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Username ne može biti prazno polje";
                    } else if (value.length < 3) {
                      return "Username ne može sadržati manje od 3 karaktera";
                    }
                    return null;
                  },
                  controller: _username,
                  decoration: const InputDecoration(
                    labelText: "Username",
                  ),
                  maxLines: 1,
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: textFieldWidth,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password ne može biti prazno polje";
                    } else if (value.length < 4) {
                      return "Password ne može sadržati manje od 4 karaktera";
                    }
                    return null;
                  },
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                  maxLines: 1,
                  style: TextStyle(fontSize: fontSize),
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
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: fontSize),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
