import 'package:e_cakeshop_mobile/providers/cart_provider.dart';
import 'package:e_cakeshop_mobile/screens/stripe_payment.dart';
import 'package:e_cakeshop_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Shopping Cart', style: TextStyle(color: Colors.white)),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: cartProvider.cart.items.length,
                itemBuilder: (BuildContext context, int index) {
                  var cartItem = cartProvider.cart.items[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: _buildImage(cartItem.product.slika),
                      ),
                      title: Text(cartItem.product.naziv ?? ''),
                      subtitle:
                          Text('Price: ${cartItem.product.cijena.toString()}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          cartProvider.removeFromCart(cartItem.product);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total Price: ${cartProvider.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(160, 40),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, StripePaymentScreen.routeName);
                      // This will navigate to the StripePaymentScreen when the button is pressed
                    },
                    child: const Text('Proceed to Checkout',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
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
}
