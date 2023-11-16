import 'package:e_cakeshop/models/novost.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditNewsModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Novost? novostToEdit;

  EditNewsModal(
      {required this.onCancelPressed,
      required this.onUpdatePressed,
      required this.novostToEdit});

  @override
  _EditNewsModalState createState() => _EditNewsModalState();
}

class _EditNewsModalState extends State<EditNewsModal> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController thumbnailController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  late Novost? _novostToEdit;

  @override
  void initState() {
    super.initState();
    _novostToEdit = widget.novostToEdit;
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
                'Edit News',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                decoration: const InputDecoration(labelText: 'Thumbnail'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Creation date',
                  hintText: 'YYYY-MM-DD',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
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
                      try {
                        final title = titleController.text;
                        final content = contentController.text;
                        final thumbnail = thumbnailController.text;
                        final date = dateController.text;

                        if (title.isEmpty ||
                            content.isEmpty ||
                            thumbnail.isEmpty ||
                            date.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          DateTime tempDate =
                              DateFormat("yyyy-MM-dd").parse(date);

                          widget.onUpdatePressed(
                            _novostToEdit!.novostID!,
                            {
                              "naslov": title,
                              "sadrzaj": content,
                              "thumbnail": thumbnail,
                              "datumKreiranja": tempDate.toIso8601String(),
                            },
                          );
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        print("Error updating news: $e");
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
