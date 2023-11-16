import 'package:e_cakeshop/models/proizvod.dart';
import 'package:e_cakeshop/models/vrstaproizvoda.dart';
import 'package:e_cakeshop/providers/vrstaproizvoda_provider.dart';
import 'package:flutter/material.dart';

class EditProductModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Proizvod? proizvodToEdit;

  EditProductModal(
      {required this.onCancelPressed,
      required this.onUpdatePressed,
      required this.proizvodToEdit});

  @override
  _EditProductModalState createState() => _EditProductModalState();
}

class _EditProductModalState extends State<EditProductModal> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  late Proizvod? _proizvodToEdit;
  List<VrstaProizvoda> vrstaProizvodaList = [];
  String? selectedVrstaProizvoda;

  Future<void> loadData() async {
    try {
      vrstaProizvodaList =
          vrstaProizvodaList = await VrstaProizvodaProvider().Get();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  int extractIdFromList<T>(
    String? selectedValue,
    List<T> list,
    int Function(T) getId,
  ) {
    if (selectedValue != null) {
      T selectedObject = list.firstWhere(
        (item) => getId(item).toString() == selectedValue,
        orElse: () => list.first,
      );

      return getId(selectedObject);
    }
    return -1;
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
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image'),
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
                      onPressed: () {
                        try {
                          final name = nameController.text;
                          final price = priceController.text;
                          final image = imageController.text;
                          final description = descriptionController.text;

                          if (name.isEmpty ||
                              price.isEmpty ||
                              image.isEmpty ||
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
                                "slika": image,
                                "opis": description,
                                "vrstaProizvodaID": vrstaProizvodaID,
                              },
                            );
                            Navigator.pop(context);
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
