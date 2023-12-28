// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:e_cakeshop_admin/models/novost.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditNewsModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Novost? novostToEdit;

  const EditNewsModal({
    required this.onCancelPressed,
    required this.onUpdatePressed,
    required this.novostToEdit,
  });

  @override
  _EditNewsModalState createState() => _EditNewsModalState();
}

class _EditNewsModalState extends State<EditNewsModal> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  late Novost? _novostToEdit;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
        }
      });
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _editNews() async {
    try {
      if (_imageFile != null) {
        List<int> imageBytes = await _imageFile!.readAsBytes();
        String base64Image = base64Encode(imageBytes);

        final title = titleController.text;
        final content = contentController.text;
        final date = dateController.text;

        if (title.isEmpty || content.isEmpty || date.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill all fields'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          DateTime tempDate = DateFormat("yyyy-MM-dd").parse(date);

          widget.onUpdatePressed(
            _novostToEdit!.novostID!,
            {
              "naslov": title,
              "sadrzaj": content,
              "thumbnail": base64Image,
              "datumKreiranja": tempDate.toIso8601String(),
            },
          );
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error updating news: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _novostToEdit = widget.novostToEdit;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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
                const SizedBox(height: 20),
                _imageFile != null
                    ? Image.file(_imageFile!)
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(97, 142, 246, 1),
                        ),
                        onPressed: _pickImage,
                        child: const Text('Select Thumbnail'),
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
                      onPressed: _editNews,
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
