import 'package:e_cakeshop/models/vrstaproizvoda.dart';
import 'package:e_cakeshop/providers/vrstaproizvoda_provider.dart';
import 'package:flutter/material.dart';

class AddProductModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final Function(Map<String, dynamic>) onAddProductPressed;

  AddProductModal(
      {required this.onCancelPressed, required this.onAddProductPressed});

  @override
  _AddProductModalState createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

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
    loadData();
    super.initState();
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
                  'Add Product',
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
                      value: vrstaProizvoda.naziv,
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

                            if (vrstaProizvodaID != -1) {
                              Map<String, dynamic> newProduct = {
                                "naziv": name,
                                "cijena": price,
                                "slika": image,
                                "opis": description,
                                "vrstaProizvodaID": vrstaProizvodaID,
                              };

                              widget.onAddProductPressed(newProduct);
                              setState(() {});
                            } else {
                              print("Error: Some selected values are not set");
                            }
                          }
                        } catch (e) {
                          print("Error adding product: $e");
                        }
                      },
                      child: const Text('OK'),
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
