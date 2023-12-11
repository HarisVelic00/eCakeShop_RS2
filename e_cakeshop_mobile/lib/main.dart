import 'package:e_cakeshop_mobile/providers/cart_provider.dart';
import 'package:e_cakeshop_mobile/providers/korisnik_provider.dart';
import 'package:e_cakeshop_mobile/providers/narudzba_provider.dart';
import 'package:e_cakeshop_mobile/providers/uplata_provider.dart';
import 'package:e_cakeshop_mobile/screens/cart_screen.dart';
import 'package:e_cakeshop_mobile/screens/home_screen.dart';
import 'package:e_cakeshop_mobile/screens/map_screen.dart';
import 'package:e_cakeshop_mobile/screens/review_screen.dart';
import 'package:e_cakeshop_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

void main() {
  Stripe.publishableKey =
      'pk_test_51OJIXNLfQTkXq96LfxTnxkTBRc0zPXjw0DIFT1HT1zCDRlGP35YY3SYI0M89Rcct7GPcqiHoIk8gM0X2l0aBYvfZ00q3YBLWX8';
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
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => NarudzbaProvider()),
        ChangeNotifierProvider(create: (_) => UplataProvider()),
      ],
      child: MaterialApp(
        initialRoute: LoginScreen.routeName,
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          ReviewScreen.routeName: (context) => ReviewScreen(),
          MapScreen.routeName: (context) => MapScreen(),
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late KorisnikProvider _korisnikProvider;
  final _formKey = GlobalKey<FormState>();
  static const String routeName = "/login";

  void handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        print('Entered username: ${_username.text}');
        print('Entered password: ${_password.text}');

        Authorization.Username = _username.text;
        Authorization.Password = _password.text;

        _korisnikProvider =
            Provider.of<KorisnikProvider>(context, listen: false);

        print(
            'Authenticating with username: ${Authorization.Username} and password: ${Authorization.Password}');
        Authorization.korisnik = await _korisnikProvider.Authenticate();

        print('Korisnik returned from database: ${Authorization.korisnik}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            duration: Duration(seconds: 3),
          ),
        );

        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
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
        title: const Text('eCakeShop', style: TextStyle(color: Colors.white)),
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
                child:
                    const Text("Login", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
