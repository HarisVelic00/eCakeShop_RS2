// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:e_cakeshop_admin/models/vrstaproizvoda.dart';
import 'package:e_cakeshop_admin/providers/vrstaproizvoda_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final Function(Map<String, dynamic>) onAddProductPressed;

  const AddProductModal(
      {required this.onCancelPressed, required this.onAddProductPressed});

  @override
  _AddProductModalState createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? selectedVrstaProizvoda;
  List<VrstaProizvoda> vrstaProizvodaList = [];
  bool _imageError = false;

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
      vrstaProizvodaList = await VrstaProizvodaProvider().Get();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _uploadProizvod() async {
    try {
      List<int> imageBytes = await _imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      final name = nameController.text;
      final description = descriptionController.text;
      final price = double.tryParse(priceController.text);

      int vrstaProizvodaID = findIdFromName(
        selectedVrstaProizvoda,
        vrstaProizvodaList,
        (VrstaProizvoda _vrstaP) => _vrstaP.naziv ?? '',
        (VrstaProizvoda _vrstaP) => _vrstaP.vrstaProizvodaID ?? -1,
      );

      if (vrstaProizvodaID != -1) {
        Map<String, dynamic> newProduct = {
          "naziv": name,
          "cijena": price,
          "slika": base64Image,
          "opis": description,
          "vrstaProizvodaID": vrstaProizvodaID,
        };

        widget.onAddProductPressed(newProduct);
        Navigator.pop(context);
        setState(() {});
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
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
        child: Container(
          color: const Color.fromRGBO(247, 249, 253, 1),
          width: MediaQuery.of(context).size.width * 0.2,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Add Product',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Example: Cheese Cake',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter product name';
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Product name can only contain letters';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: priceController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product price';
                        }
                        if (!RegExp(r'^[0-9]+(\.[0-9]+)?$').hasMatch(value)) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        hintText: 'Example: 40',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
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
                    TextFormField(
                      controller: descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product description';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Example: Cake with cheese',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedVrstaProizvoda,
                      onChanged: (String? value) {
                        setState(() {
                          selectedVrstaProizvoda = value;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a product type';
                        }
                        return null;
                      },
                      items: vrstaProizvodaList
                          .map((VrstaProizvoda _vrstaProizvoda) {
                        return DropdownMenuItem<String>(
                          value: _vrstaProizvoda.naziv,
                          child: Text(_vrstaProizvoda.naziv ?? ''),
                        );
                      }).toList(),
                      decoration:
                          const InputDecoration(labelText: 'Product Type'),
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
                                _uploadProizvod();
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
