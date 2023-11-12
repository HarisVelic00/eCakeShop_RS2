// ignore_for_file: unused_local_variable

import 'package:e_cakeshop/models/novost.dart';
import 'package:flutter/material.dart';

class AddNewsModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final Function(Novost) onAddNewsPressed;

  AddNewsModal({required this.onCancelPressed, required this.onAddNewsPressed});

  @override
  _AddNewsModalState createState() => _AddNewsModalState();
}

class _AddNewsModalState extends State<AddNewsModal> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController thumbnailController = TextEditingController();

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
                  'Add News',
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
                // TextField(
                //   controller: thumbnailController,
                //   decoration: const InputDecoration(labelText: 'Thumbnail URL'),
                // ),
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

                        Novost newNews = Novost(
                          naslov: title, 
                          sadrzaj: content);












                        widget.onAddNewsPressed(newNews);

                          Navigator.pop(context);
                          setState(() {});
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
