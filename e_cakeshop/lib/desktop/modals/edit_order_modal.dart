import 'package:e_cakeshop/models/narudzba.dart';
import 'package:flutter/material.dart';

class EditOrderModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final void Function(int, Map<String, dynamic>) onUpdatePressed;
  final Narudzba? narudzbaToEdit;

  EditOrderModal({
    required this.onCancelPressed,
    required this.onUpdatePressed,
    required this.narudzbaToEdit,
  });

  @override
  _EditOrderModalState createState() => _EditOrderModalState();
}

class _EditOrderModalState extends State<EditOrderModal> {
  late Narudzba? _narudzbaToEdit;

  ValueNotifier<bool> isShippedController = ValueNotifier<bool>(false);
  ValueNotifier<bool> isCanceledController = ValueNotifier<bool>(false);

  Future<void> _editOrder() async {
    try {
      widget.onUpdatePressed(_narudzbaToEdit!.narudzbaID!, {
        "isShipped": isShippedController.value,
        "isCanceled": isCanceledController.value,
      });
      Navigator.pop(context);
    } catch (e) {
      print('Error editing order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error editing order'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _narudzbaToEdit = widget.narudzbaToEdit;

    if (_narudzbaToEdit != null) {
      isShippedController.value = _narudzbaToEdit!.isShipped ?? false;
      isCanceledController.value = _narudzbaToEdit!.isCanceled ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: const Color.fromRGBO(247, 249, 253, 1),
        width: MediaQuery.of(context).size.width * 0.2,
        child: SingleChildScrollView(
          child: Padding(
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
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Is Shipped'),
                        ValueListenableBuilder<bool>(
                          valueListenable: isShippedController,
                          builder: (context, value, child) {
                            return Checkbox(
                              value: value,
                              onChanged: (bool? newValue) {
                                isShippedController.value = newValue ?? false;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Is Canceled'),
                        ValueListenableBuilder<bool>(
                          valueListenable: isCanceledController,
                          builder: (context, value, child) {
                            return Checkbox(
                              value: value,
                              onChanged: (bool? newValue) {
                                isCanceledController.value = newValue ?? false;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
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
                      onPressed: _editOrder,
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
