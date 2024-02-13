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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? selectedVrstaProizvoda;
  List<VrstaProizvoda> vrstaProizvodaList = [];

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
      final name = nameController.text;
      final description = descriptionController.text;
      final price = double.tryParse(priceController.text);

      if (name.isEmpty ||
          description.isEmpty ||
          selectedVrstaProizvoda == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all fields'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (price == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Price should only contain numbers.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (price <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Price should be greater than zero.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Name should contain only letters.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (!RegExp(r'^[a-zA-Z0-9,.!? ]+$').hasMatch(description)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Description should contain only letters, numbers, . , !, and ?'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      } else {
        int vrstaProizvodaID = findIdFromName(
          selectedVrstaProizvoda,
          vrstaProizvodaList,
          (VrstaProizvoda _vrstaP) => _vrstaP.naziv ?? '',
          (VrstaProizvoda _vrstaP) => _vrstaP.vrstaProizvodaID ?? -1,
        );

        if (vrstaProizvodaID != -1) {
          List<int> imageBytes = await _imageFile!.readAsBytes();
          String base64Image = base64Encode(imageBytes);

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
        } else {
          print("Error: Selected value not found in vrstaProizvodaList");
        }
      }
    } catch (e) {
      print("Error adding product: $e");
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
                    'Add Product',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Example: Cheese Cake',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      hintText: 'Example: 40',
                      hintStyle: TextStyle(color: Colors.grey),
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
                        onPressed: _uploadProizvod,
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
