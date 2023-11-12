// ignore_for_file: unused_local_variable

import 'package:e_cakeshop/models/narudzba.dart';
import 'package:flutter/material.dart';

class EditOrderModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final VoidCallback onSavePressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Narudzba? narudzbaToEdit;
  EditOrderModal(
      {required this.onCancelPressed,
      required this.onSavePressed,
      required this.onUpdatePressed,
      required this.narudzbaToEdit});

  @override
  _EditOrderModalState createState() => _EditOrderModalState();
}

class _EditOrderModalState extends State<EditOrderModal> {
  final TextEditingController orderNumberController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController productsController = TextEditingController();
  final TextEditingController isShippedController = TextEditingController();
  final TextEditingController isCanceledController = TextEditingController();

  late Narudzba? _narudzbaToEdit; // Local variable

  @override
  void initState() {
    super.initState();
    _narudzbaToEdit = widget.narudzbaToEdit; // Initialize the local variable
    // TODO: Initialize controllers with data if needed
  }

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
                  'Edit Order',
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
                        final orderNumber = orderNumberController.text;
                        final user = userController.text;
                        final date = dateController.text;
                        final products = productsController.text;
                        final isShipped = isShippedController.text;
                        final isCanceled = isCanceledController.text;

                        widget.onUpdatePressed(_narudzbaToEdit!.narudzbaID!, {
                          'brojNarudzbe': orderNumber,
                          'korisnik': user,
                          'datumNarudzbe': date,
                          'proizvodi': products,
                          'isCanceled': isCanceled,
                          'isShipped': isShipped,
                        });
                        widget.onSavePressed();
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
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
