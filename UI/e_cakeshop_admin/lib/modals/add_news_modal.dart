// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously, non_constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'package:e_cakeshop_admin/models/korisnik.dart';
import 'package:e_cakeshop_admin/providers/korisnik_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewsModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final Function(Map<String, dynamic>) onAddNewsPressed;

  const AddNewsModal(
      {required this.onCancelPressed, required this.onAddNewsPressed});

  @override
  _AddNewsModalState createState() => _AddNewsModalState();
}

class _AddNewsModalState extends State<AddNewsModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController thumbnailController = TextEditingController();
  List<Korisnik> korisnikList = [];
  String? selectedKorisnik;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _imageError = false;

  int findIdFromName<T>(
    String? selectedValue,
    List<T> list,
    String Function(T) getName,
    int Function(T) getId,
  ) {
    if (selectedValue != null) {
      T selectedObject = list.firstWhere(
        (item) => getName(item) == selectedValue,
        orElse: () => list.first,
      );

      return getId(selectedObject);
    }
    return -1;
  }

  Future<void> loadData() async {
    try {
      korisnikList = await KorisnikProvider().Get();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

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

  Future<void> _uploadThumbnail() async {
    try {
      List<int> imageBytes = await _imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      final title = titleController.text;
      final content = contentController.text;

      int korisnikID = findIdFromName(
        selectedKorisnik,
        korisnikList,
        (Korisnik korisnik) => korisnik.ime ?? '',
        (Korisnik korisnik) => korisnik.korisnikID ?? -1,
      );

      if (korisnikID != -1) {
        Map<String, dynamic> newNews = {
          "naslov": title,
          "sadrzaj": content,
          "thumbnail": base64Image,
          "datumKreiranja": DateTime.now().toIso8601String(),
          "korisnikID": korisnikID,
        };

        widget.onAddNewsPressed(newNews);
        setState(() {});
        Navigator.pop(context);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          child: Container(
            color: const Color.fromRGBO(247, 249, 253, 1),
            width: MediaQuery.of(context).size.width * 0.2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
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
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Example: Cheese Cake',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter news title';
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Title can only contain letters';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: contentController,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        hintText: 'Example: This cake is delicious!',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter news content';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _imageFile != null
                        ? Image.file(_imageFile!)
                        : Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(97, 142, 246, 1),
                                ),
                                onPressed: _pickImage,
                                child: const Text('Select Image',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              _imageError
                                  ? const Text(
                                      'Please select an image',
                                      style: TextStyle(color: Colors.red),
                                    )
                                  : Container(),
                            ],
                          ),
                    DropdownButtonFormField<String>(
                      value: selectedKorisnik,
                      onChanged: (String? value) {
                        setState(() {
                          selectedKorisnik = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a user';
                        }
                        return null;
                      },
                      items: korisnikList.map((Korisnik korisnik) {
                        return DropdownMenuItem<String>(
                          value: korisnik.ime ?? '',
                          child: Text(korisnik.ime ?? ''),
                        );
                      }).toList(),
                      decoration: const InputDecoration(labelText: 'User'),
                      dropdownColor: const Color.fromRGBO(247, 249, 253, 1),
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_imageFile == null) {
                                setState(() {
                                  _imageError = true;
                                });
                              } else {
                                _uploadThumbnail();
                              }
                            }
                          },
                          child: const Text('OK',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
