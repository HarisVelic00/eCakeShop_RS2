// ignore_for_file: unused_local_variable

import 'package:e_cakeshop/models/narudzba.dart';
import 'package:flutter/material.dart';

class AddOrderModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final Function(Narudzba) onAddOrderPressed;

  AddOrderModal(
      {required this.onCancelPressed, required this.onAddOrderPressed});

  @override
  _AddOrderModalState createState() => _AddOrderModalState();
}

class _AddOrderModalState extends State<AddOrderModal> {
  final TextEditingController orderNumberController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController productsController = TextEditingController();
  final TextEditingController isShippedController = TextEditingController();
  final TextEditingController isCanceledController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: const Color.fromRGBO(227, 232, 247, 1),
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Add Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: orderNumberController,
                  decoration: const InputDecoration(labelText: 'Order Number'),
                ),
                TextField(
                  controller: userController,
                  decoration: const InputDecoration(labelText: 'User'),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                ),
                TextField(
                  controller: productsController,
                  decoration: const InputDecoration(labelText: 'Products'),
                ),
                TextField(
                  controller: isShippedController,
                  decoration: const InputDecoration(labelText: 'Is Shipped'),
                ),
                TextField(
                  controller: isCanceledController,
                  decoration: const InputDecoration(labelText: 'Is Canceled'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      onPressed: widget.onCancelPressed,
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
                      ),
                      onPressed: () {
                        try {
                          final orderNumber = orderNumberController.text;
                          final user = userController.text;
                          final date = dateController.text;
                          final products = productsController.text;
                          final isShipped = isShippedController.text;
                          final isCanceled = isCanceledController.text;

                          Narudzba newOrder = Narudzba(
                            brojNarudzbe: orderNumber,
                            // korisnik: user,
                            // datumNarudzbe: date,
                            // proizvodi: products,
                            // isCanceled: isCanceled,
                            // isShipped: isShipped,
                          );
                          Navigator.pop(context);
                          setState(() {});
                        } catch (e) {
                          print("Error adding user: $e");
                        }
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
