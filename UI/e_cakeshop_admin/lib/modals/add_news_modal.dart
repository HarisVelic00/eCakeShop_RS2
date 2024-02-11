// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously
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
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController thumbnailController = TextEditingController();

  List<Korisnik> korisnikList = [];
  String? selectedKorisnik;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

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
      if (_imageFile != null) {
        List<int> imageBytes = await _imageFile!.readAsBytes();
        String base64Image = base64Encode(imageBytes);

        final title = titleController.text;
        final content = contentController.text;

        if (title.isEmpty || content.isEmpty) {
          throw Exception('Please fill all fields.');
        }

        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(title)) {
          throw Exception('Title should contain only letters.');
        }

        if (!RegExp(r'^[a-zA-Z,. ]+$').hasMatch(content)) {
          throw Exception('Content should contain only letters.');
        }

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
        } else {
          throw Exception('Error: Some selected values are not set');
        }
      } else {
        throw Exception('No image selected. Please select an image.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
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
                          child: const Text('Select Thumbnail',
                              style: TextStyle(color: Colors.white)),
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
                          backgroundColor:
                              const Color.fromRGBO(97, 142, 246, 1),
                        ),
                        onPressed: _uploadThumbnail,
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
    );
  }
}
