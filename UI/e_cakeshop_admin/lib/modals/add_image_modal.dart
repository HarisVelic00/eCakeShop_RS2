// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:e_cakeshop_admin/models/korisnik.dart';
import 'package:e_cakeshop_admin/providers/korisnik_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImageModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final Function(Map<String, dynamic>) onAddSlikaPressed;

  const AddImageModal(
      {required this.onCancelPressed, required this.onAddSlikaPressed});

  @override
  _AddImageModalState createState() => _AddImageModalState();
}

class _AddImageModalState extends State<AddImageModal> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController descriptionController = TextEditingController();
  List<Korisnik> korisnikList = [];
  String? selectedKorisnik;

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

  @override
  void initState() {
    super.initState();
    loadData();
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

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      List<int> imageBytes = await _imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      final opis = descriptionController.text;

      if (opis.isEmpty || selectedKorisnik == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      int korisnikID = findIdFromName(
        selectedKorisnik,
        korisnikList,
        (Korisnik korisnik) => korisnik.ime ?? '',
        (Korisnik korisnik) => korisnik.korisnikID ?? -1,
      );

      if (korisnikID != -1) {
        Map<String, dynamic> newSlika = {
          "slikaByte": base64Image,
          "opis": opis,
          "korisnikID": korisnikID,
        };

        widget.onAddSlikaPressed(newSlika);
        setState(() {});
        Navigator.pop(context);
      } else {
        print("Error: Some selected values are not set");
      }
    } else {
      print('No image selected');
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
          child: Padding(
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
                const SizedBox(height: 20),
                _imageFile != null
                    ? Image.file(_imageFile!)
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(97, 142, 246, 1),
                        ),
                        onPressed: _pickImage,
                        child: const Text('Select Image',
                            style: TextStyle(color: Colors.white)),
                      ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedKorisnik,
                  onChanged: (String? value) {
                    setState(() {
                      selectedKorisnik = value!;
                    });
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
                        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
                      ),
                      onPressed: _uploadImage,
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
    );
  }
}
