import 'package:e_cakeshop/models/slika.dart';
import 'package:flutter/material.dart';

class EditImageModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Slika? slikaToEdit;

  EditImageModal({
    required this.onCancelPressed,
    required this.onUpdatePressed,
    required this.slikaToEdit,
  });

  @override
  _EditImageModalState createState() => _EditImageModalState();
}

class _EditImageModalState extends State<EditImageModal> {
  final TextEditingController imageByteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late Slika? _slikaToEdit;

  @override
  void initState() {
    super.initState();
    _slikaToEdit = widget.slikaToEdit;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: const Color.fromRGBO(247, 249, 253, 1),
        width: MediaQuery.of(context).size.width * 0.2,
        child: Padding(
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
              TextField(
                controller: imageByteController,
                decoration: const InputDecoration(labelText: 'Image'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
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
                    onPressed: () {
                      final slika = imageByteController.text;
                      final opis = descriptionController.text;

                      if (slika.isEmpty || opis.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fields'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        try {
                          widget.onUpdatePressed(_slikaToEdit!.slikaID!, {
                            "slikaByte": slika,
                            "opis": opis,
                          });
                          Navigator.pop(context);
                        } catch (e) {
                          print("Error adding image: $e");
                        }
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
    );
  }
}
