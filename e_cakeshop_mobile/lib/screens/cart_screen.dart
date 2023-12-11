import 'dart:convert';
import 'package:e_cakeshop_mobile/models/cart.dart';
import 'package:e_cakeshop_mobile/models/uplata.dart';
import 'package:e_cakeshop_mobile/providers/cart_provider.dart';
import 'package:e_cakeshop_mobile/providers/narudzba_provider.dart';
import 'package:e_cakeshop_mobile/providers/uplata_provider.dart';
import 'package:e_cakeshop_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  static const String routeName = "/cart";
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartProvider _cartProvider;
  NarudzbaProvider? _narudzbaProvider;
  UplataProvider? _uplataProvider;
  Map<String, dynamic>? paymentIntentData;
  Uplata? uplata;
  double iznos = 0;

  @override
  Widget build(BuildContext context) {
    _cartProvider = Provider.of<CartProvider>(context);
    _narudzbaProvider = Provider.of<NarudzbaProvider>(context);
    _uplataProvider = Provider.of<UplataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(222, 235, 251, 1),
        child: Column(
          children: [
            Expanded(child: _buildProductCardList(_cartProvider)),
            if (_cartProvider.cart.items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ukupno: ${_cartProvider.totalPrice.toStringAsFixed(2)} KM',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await makePayment(_cartProvider.totalPrice);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green,
                        ),
                      ),
                      child: const Text(
                        "Kupi",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCardList(CartProvider cartProvider) {
    if (cartProvider.cart.items.isEmpty) {
      return const Center(
        child: Text("Korpa je trenutno prazna"),
      );
    }

    return Container(
      child: ListView.builder(
        itemCount: cartProvider.cart.items.length,
        itemBuilder: (context, index) {
          return _buildProductCard(context, cartProvider.cart.items[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, CartItem item) {
    var cartProvider = Provider.of<CartProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: const Color.fromRGBO(247, 249, 253, 1),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: _buildImage(item.product.slika),
        ),
        title:
            Text("${item.product.naziv} | Kolicina: ${item.count.toString()}"),
        subtitle: Text(
            "Cijena ${item.product.cijena.toString()} | Ukupno: ${(item.product.cijena! * item.count).toString()}"),
        trailing: IconButton(
          onPressed: () {
            cartProvider.removeFromCart(item.product);
          },
          icon: const Icon(Icons.delete_forever),
          iconSize: 30.0,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return imageUrl != null
        ? Image.memory(
            dataFromBase64String(imageUrl),
            fit: BoxFit.cover,
          )
        : const Text('No Image');
  }

  Future<void> makePayment(double iznos) async {
    try {
      paymentIntentData =
          await createPaymentIntent((iznos * 100).round().toString(), 'bam');
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              googlePay: const PaymentSheetGooglePay(
                  merchantCountryCode: 'BIH', testEnv: true),
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              style: ThemeMode.light,
              merchantDisplayName: 'eCakeShop',
            ),
          )
          .then((value) {});

      displayPaymentSheet();
    } catch (e, s) {
      print('exception: $e $s');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization':
              'Bearer sk_test_51OJIXNLfQTkXq96LiFrGOfZf07BIKmRb0A2dWDqxfd7IEQ2AuN97esPWexCDz9dkm7cZ3czSGVDZpVn88cEt1P0w00Hwb1ITVq',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
      rethrow;
    }
  }

  Future<void> insertUplata(double amount, String brojTransakcije) async {
    Map<String, dynamic> request = {
      "iznos": amount,
      "brojTransakcije": brojTransakcije,
    };

    uplata = await _uplataProvider!.insert(request);
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().onError((error, stackTrace) {
        throw Exception(error);
      });

      await insertUplata(iznos, paymentIntentData!['id']);

      List<Map<String, dynamic>> narudzbaProizvodi = [];
      _cartProvider.cart.items.forEach((element) {
        narudzbaProizvodi.add({
          "proizvodID": element.product.proizvodID,
          "kolicina": element.count,
        });
      });
      Map<String, dynamic> narudzba = {
        "korisnikID": Authorization.korisnik!.korisnikID,
        "uplataID": uplata!.uplataID,
        "listaProizvoda": narudzbaProizvodi
      };

      await _narudzbaProvider!.insert(narudzba);
      setState(() {
        paymentIntentData = null;
        _cartProvider.cart.items.clear();
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Uplata uspjesna")));
    } on StripeException catch (e) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Ponistena transakcija"),
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  void clearCart(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.clearCart();
  }
}
