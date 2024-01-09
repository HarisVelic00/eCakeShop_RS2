// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, unused_local_variable
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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
  MemoryImage? _decodedImage;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
          _updateImagePreview();
        }
      });
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _updateImagePreview() {
    if (_imageFile != null) {
      setState(() {
        _decodeImageAndUpdatePreview();
      });
    }
  }

  void _decodeImageAndUpdatePreview() async {
    try {
      List<int> imageBytes = await _imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      setState(() {
        _decodedImage = MemoryImage(Uint8List.fromList(imageBytes));
      });
    } catch (e) {
      print('Error decoding image: $e');
    }
  }

  Widget _buildImagePreview() {
    return SizedBox(
      width: 256,
      height: 256,
      child: _decodedImage != null
          ? Image.memory(
              _decodedImage!.bytes,
              width: 256,
              height: 256,
              fit: BoxFit.cover,
            )
          : Container(),
    );
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
          DateTime tempDate = DateFormat("MM.dd.yyyy").parse(date);

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

    if (_novostToEdit != null) {
      titleController.text = _novostToEdit!.naslov ?? '';
      contentController.text = _novostToEdit!.sadrzaj ?? '';
      DateTime datumKreiranja = _novostToEdit!.datumKreiranja!;
      String formattedDate = DateFormat('MM.dd.yyyy').format(datumKreiranja);
      dateController.text = formattedDate;

      if (_novostToEdit!.thumbnail != null &&
          _novostToEdit!.thumbnail!.isNotEmpty) {
        try {
          List<int> imageBytes = base64Decode(_novostToEdit!.thumbnail!);
          setState(() {
            _decodedImage = MemoryImage(Uint8List.fromList(imageBytes));
          });
        } catch (e) {
          print('Error decoding image: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: const Color.fromRGBO(247, 249, 253, 1),
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    _buildImagePreview(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
                      ),
                      onPressed: _pickImage,
                      child: const Text('Select Thumbnail',
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Creation date',
                        hintText: 'MM.dd.yyyy',
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
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(97, 142, 246, 1),
                          ),
                          onPressed: _editNews,
                          child: const Text('OK',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
