// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:e_cakeshop_admin/models/proizvod.dart';
import 'package:e_cakeshop_admin/models/vrstaproizvoda.dart';
import 'package:e_cakeshop_admin/providers/vrstaproizvoda_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProductModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Proizvod? proizvodToEdit;

  const EditProductModal({
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
  MemoryImage? _decodedImage;

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

  @override
  void initState() {
    super.initState();
    _proizvodToEdit = widget.proizvodToEdit;

    if (_proizvodToEdit != null) {
      nameController.text = _proizvodToEdit!.naziv ?? '';
      priceController.text = _proizvodToEdit!.cijena.toString();
      descriptionController.text = _proizvodToEdit!.opis ?? '';
      selectedVrstaProizvoda = _proizvodToEdit!.vrstaProizvoda?.naziv ?? '';

      if (_proizvodToEdit!.slika != null &&
          _proizvodToEdit!.slika!.isNotEmpty) {
        try {
          List<int> imageBytes = base64Decode(_proizvodToEdit!.slika!);
          setState(() {
            _decodedImage = MemoryImage(Uint8List.fromList(imageBytes));
          });
        } catch (e) {
          print('Error decoding image: $e');
        }
      }
    }

    loadData();
  }

  void _editProduct() async {
    try {
      if (_imageFile != null) {
        List<int> imageBytes = await _imageFile!.readAsBytes();
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
            (VrstaProizvoda vrstaProizvoda) => vrstaProizvoda.naziv ?? '',
            (VrstaProizvoda vrstaProizvoda) =>
                vrstaProizvoda.vrstaProizvodaID ?? -1,
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
                      TextField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedVrstaProizvoda,
                        onChanged: (String? value) {
                          setState(() {
                            selectedVrstaProizvoda = value!;
                          });
                        },
                        items: vrstaProizvodaList
                            .map((VrstaProizvoda vrstaProizvoda) {
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
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.white)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(97, 142, 246, 1),
                            ),
                            onPressed: _editProduct,
                            child: const Text('Save',
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
