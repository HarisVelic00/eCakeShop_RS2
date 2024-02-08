// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:e_cakeshop_admin/models/slika.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditImageModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Slika? slikaToEdit;

  const EditImageModal({
    required this.onCancelPressed,
    required this.onUpdatePressed,
    required this.slikaToEdit,
  });

  @override
  _EditImageModalState createState() => _EditImageModalState();
}

class _EditImageModalState extends State<EditImageModal> {
  final TextEditingController descriptionController = TextEditingController();
  late Slika? _slikaToEdit;
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
      final decodedImage = MemoryImage(Uint8List.fromList(imageBytes));
      setState(() {
        _decodedImage = decodedImage;
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

  Future<void> _editImage() async {
    try {
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a different image.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      List<int>? imageBytes = await _imageFile!.readAsBytes();
      String? base64Image = base64Encode(imageBytes);

      final opis = descriptionController.text;

      if (opis.isEmpty || opis.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all fields.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(opis)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Description should contain only letters.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        try {
          if (_slikaToEdit != null) {
            widget.onUpdatePressed(_slikaToEdit!.slikaID!, {
              "slikaByte": base64Image,
              "opis": opis,
            });
          } else {
            print("Error: Image to edit is null");
          }
          Navigator.pop(context);
        } catch (e) {
          print("Error editing image: $e");
        }
      }
    } catch (e) {
      print("Error editing image: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _slikaToEdit = widget.slikaToEdit;

    if (_slikaToEdit != null) {
      descriptionController.text = _slikaToEdit!.opis ?? '';

      if (_slikaToEdit!.slikaByte != null &&
          _slikaToEdit!.slikaByte!.isNotEmpty) {
        try {
          List<int> imageBytes = base64Decode(_slikaToEdit!.slikaByte!);
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        'Edit Image',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                      ),
                      const SizedBox(height: 20),
                      _buildImagePreview(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(97, 142, 246, 1),
                        ),
                        onPressed: _pickImage,
                        child: const Text('Select Image',
                            style: TextStyle(color: Colors.white)),
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
                            onPressed: _editImage,
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
      ),
    );
  }
}
