// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class EditArchiveModal extends StatefulWidget {
  final VoidCallback onCancelPressed;

  EditArchiveModal({required this.onCancelPressed});

  @override
  _EditArchiveModalState createState() => _EditArchiveModalState();
}

class _EditArchiveModalState extends State<EditArchiveModal> {
  final TextEditingController orderNumberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController isCanceledController = TextEditingController();
  final TextEditingController isShippedController = TextEditingController();

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
                  'Edit Archived Order',
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
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                ),
                TextField(
                  controller: userController,
                  decoration: const InputDecoration(labelText: 'User'),
                ),
                TextField(
                  controller: productController,
                  decoration: const InputDecoration(labelText: 'Product'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: isCanceledController,
                  decoration: const InputDecoration(labelText: 'Is Canceled'),
                ),
                TextField(
                  controller: isShippedController,
                  decoration: const InputDecoration(labelText: 'Is Shipped'),
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
                        final date = dateController.text;
                        final user = userController.text;
                        final product = productController.text;
                        final price = priceController.text;
                        final isCanceled = isCanceledController.text;
                        final isShipped = isShippedController.text;

                        // Perform your desired actions with the edited data

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
