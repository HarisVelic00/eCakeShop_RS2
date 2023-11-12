// ignore_for_file: unused_local_variable

import 'package:e_cakeshop/models/novost.dart';
import 'package:flutter/material.dart';

class EditNewsModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final VoidCallback onSavePressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Novost? novostToEdit;

  EditNewsModal(
      {required this.onCancelPressed,
      required this.onSavePressed,
      required this.onUpdatePressed,
      required this.novostToEdit});

  @override
  _EditNewsModalState createState() => _EditNewsModalState();
}

class _EditNewsModalState extends State<EditNewsModal> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController thumbnailController = TextEditingController();

  late Novost? _novostToEdit;

  @override
  void initState() {
    super.initState();
    _novostToEdit = widget.novostToEdit; // Initialize the local variable
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
                  'Edit News',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: 'Content'),
                ),
                TextField(
                  controller: thumbnailController,
                  decoration: const InputDecoration(labelText: 'Thumbnail URL'),
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
                        final title = titleController.text;
                        final content = contentController.text;
                        //final thumbnail = thumbnailController.text;

                        widget.onUpdatePressed(_novostToEdit!.novostID!, {
                          'naslov': title,
                          'sadrzaj': content,
                          //'slika': thumbnail,
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