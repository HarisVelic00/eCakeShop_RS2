// ignore_for_file: use_build_context_synchronously, avoid_print, unused_catch_clause
import 'dart:convert';
import 'package:e_cakeshop_mobile/.env';
import 'package:e_cakeshop_mobile/models/cart.dart';
import 'package:e_cakeshop_mobile/models/uplata.dart';
import 'package:e_cakeshop_mobile/providers/cart_provider.dart';
import 'package:e_cakeshop_mobile/providers/lokacija_provider.dart';
import 'package:e_cakeshop_mobile/providers/narudzba_provider.dart';
import 'package:e_cakeshop_mobile/providers/uplata_provider.dart';
import 'package:e_cakeshop_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = "/cart";
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartProvider _cartProvider;
  final LokacijaProvider _lokacijaProvider = LokacijaProvider();
  NarudzbaProvider? _narudzbaProvider;
  UplataProvider? _uplataProvider;
  Map<String, dynamic>? paymentIntentData;
  Uplata? uplata;
  double iznos = 0;
  late TextEditingController _addressController;

  String? enteredAddress;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    final savedAddress = _prefs.getString('delivery_address');
    if (savedAddress != null) {
      setState(() {
        _addressController.text = savedAddress;
      });
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress(String address) async {
    await _prefs.setString('delivery_address', address);
    final insertedLocation = await _lokacijaProvider.insertLokacija(address);
    if (insertedLocation != null) {
      print(
          'Location inserted: ${insertedLocation.naziv}, Latitude: ${insertedLocation.Latitude}, Longitude: ${insertedLocation.Longitude}');
    } else {
      print('Failed to insert location');
    }
  }

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
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Delivery Address',
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: ${_cartProvider.totalPrice.toStringAsFixed(2)} KM',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
                            final enteredAddress = _addressController.text;
                            if (enteredAddress.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Please enter delivery address'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              await _saveAddress(enteredAddress);
                              double totalPrice = _cartProvider.totalPrice;
                              await makePayment(totalPrice);
                              if (paymentIntentData == null) {}
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green,
                            ),
                          ),
                          child: const Text(
                            "Buy",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
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
        child: Text("Cart is empty"),
      );
    }

    return SizedBox(
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
            Text("${item.product.naziv} | Quantity: ${item.count.toString()}"),
        subtitle: Text(
            "Price ${item.product.cijena.toString()} | Total: ${(item.product.cijena! * item.count).toString()}"),
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

  Future<void> makePayment(double totalPrice) async {
    try {
      iznos = totalPrice;
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
      setState(() {
        enteredAddress = _addressController.text;
      });
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
          'Authorization': 'Bearer $stripeSecretKey',
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
      for (var element in _cartProvider.cart.items) {
        narudzbaProizvodi.add({
          "proizvodID": element.product.proizvodID,
          "kolicina": element.count,
        });
      }
      Map<String, dynamic> narudzba = {
        "korisnikID": Authorization.korisnik!.korisnikID,
        "uplataID": uplata!.uplataID,
        "datumNarudzbe": DateTime.now().toIso8601String(),
        "listaProizvoda": narudzbaProizvodi
      };

      await _narudzbaProvider!.insert(narudzba);
      setState(() {
        paymentIntentData = null;
        _cartProvider.cart.items.clear();
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Payment successful")));
    } on StripeException catch (e) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Transaction failed"),
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
