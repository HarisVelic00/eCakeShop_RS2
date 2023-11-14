import 'package:e_cakeshop/models/slika.dart';
import 'package:flutter/material.dart';

class AddImageModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final Function(Slika) onAddSlikaPressed;

  AddImageModal(
      {required this.onCancelPressed, required this.onAddSlikaPressed});

  @override
  _AddImageModalState createState() => _AddImageModalState();
}

class _AddImageModalState extends State<AddImageModal> {
  final TextEditingController imageDescriptionController =
      TextEditingController();

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
                  'Add Image',
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
                        try {
                          final imageDescription =
                              imageDescriptionController.text;

                          Slika newSlika = Slika(
                            opis: imageDescription,
                          );

                          widget.onAddSlikaPressed(newSlika);
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
