import 'dart:convert';
import 'dart:io';

import 'package:e_cakeshop/models/proizvod.dart';
import 'package:e_cakeshop/models/vrstaproizvoda.dart';
import 'package:e_cakeshop/providers/vrstaproizvoda_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProductModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Proizvod? proizvodToEdit;

  EditProductModal({
    required this.onCancelPressed,
    required this.onUpdatePressed,
    required this.proizvodToEdit,
  });

  @override
  _EditProductModalState createState() => _EditProductModalState();
}

class _EditProductModalState extends State<EditProductModal> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late Proizvod? _proizvodToEdit;
  List<VrstaProizvoda> vrstaProizvodaList = [];
  String? selectedVrstaProizvoda;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> loadData() async {
    try {
      vrstaProizvodaList = await VrstaProizvodaProvider().Get();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

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

  @override
  void initState() {
    super.initState();
    _proizvodToEdit = widget.proizvodToEdit;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: const Color.fromRGBO(247, 249, 253, 1),
        width: MediaQuery.of(context).size.width * 0.2,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Edit Product',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
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
                        child: const Text('Select Image'),
                      ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedVrstaProizvoda,
                  onChanged: (String? value) {
                    setState(() {
                      selectedVrstaProizvoda = value!;
                    });
                  },
                  items:
                      vrstaProizvodaList.map((VrstaProizvoda vrstaProizvoda) {
                    return DropdownMenuItem<String>(
                      value: vrstaProizvoda.naziv ?? '',
                      child: Text(vrstaProizvoda.naziv ?? ''),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Type'),
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
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
                      ),
                      onPressed: () async {
                        try {
                          if (_imageFile != null) {
                            List<int> imageBytes =
                                await _imageFile!.readAsBytes();
                            String base64Image = base64Encode(imageBytes);
                            final name = nameController.text;
                            final price = double.tryParse(priceController.text);
                            final description = descriptionController.text;

                            if (name.isEmpty ||
                                price == null ||
                                description.isEmpty ||
                                selectedVrstaProizvoda == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              int vrstaProizvodaID = findIdFromName(
                                selectedVrstaProizvoda,
                                vrstaProizvodaList,
                                (VrstaProizvoda vrstaProizvoda) =>
                                    vrstaProizvoda.naziv ?? '',
                                (VrstaProizvoda vrstaProizvoda) =>
                                    vrstaProizvoda.vrstaproizvodaID ?? -1,
                              );

                              widget.onUpdatePressed(
                                _proizvodToEdit!.proizvodID!,
                                {
                                  "naziv": name,
                                  "cijena": price,
                                  "slika": base64Image,
                                  "opis": description,
                                  "vrstaProizvodaID": vrstaProizvodaID,
                                },
                              );
                              Navigator.pop(context);
                            }
                          }
                        } catch (e) {
                          print("Error adding product: $e");
                        }
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
