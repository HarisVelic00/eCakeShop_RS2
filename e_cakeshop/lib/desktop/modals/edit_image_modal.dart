// ignore_for_file: unused_local_variable

import 'package:e_cakeshop/models/slika.dart';
import 'package:flutter/material.dart';

class EditImageModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final VoidCallback onSavePressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Slika? slikaToEdit;

  EditImageModal(
      {required this.onCancelPressed,
      required this.onUpdatePressed,
      required this.slikaToEdit,
      required this.onSavePressed});

  @override
  _EditImageModalState createState() => _EditImageModalState();
}

class _EditImageModalState extends State<EditImageModal> {
  final TextEditingController imageDescriptionController =
      TextEditingController();

  late Slika? _slikaToEdit;
  @override
  void initState() {
    super.initState();
    _slikaToEdit = widget.slikaToEdit; // Initialize the local variable
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
                  'Edit Image',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: imageDescriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Image Description'),
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
                        final imageDescription =
                            imageDescriptionController.text;

                        widget.onUpdatePressed(
                            _slikaToEdit!.slikaID!, {'opis': imageDescription});

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
