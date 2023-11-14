import 'package:e_cakeshop/models/proizvod.dart';
import 'package:e_cakeshop/models/vrstaproizvoda.dart';
import 'package:e_cakeshop/providers/vrstaproizvoda_provider.dart';
import 'package:flutter/material.dart';

class EditProductModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final VoidCallback onSavePressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Proizvod? proizvodToEdit;

  EditProductModal(
      {required this.onCancelPressed,
      required this.onSavePressed,
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
  VrstaProizvoda selectedVrstaProizvoda = VrstaProizvoda();

  Future<void> GetVrstaProizvoda() async {
    try {
      vrstaProizvodaList = await VrstaProizvodaProvider().Get();
      if (vrstaProizvodaList.isNotEmpty) {
        selectedVrstaProizvoda = vrstaProizvodaList.first;
      }
      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _proizvodToEdit = widget.proizvodToEdit;
    GetVrstaProizvoda();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: const Color.fromRGBO(227, 232, 247, 1),
          child: Container(
            width: 300,
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
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(labelText: 'Code'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                // TextField(
                //   controller: imageController,
                //   decoration: const InputDecoration(labelText: 'Image URL'),
                // ),
                DropdownButtonFormField<VrstaProizvoda>(
                  value: selectedVrstaProizvoda,
                  onChanged: (VrstaProizvoda? value) {
                    setState(() {
                      selectedVrstaProizvoda = value!;
                    });
                  },
                  items:
                      vrstaProizvodaList.map((VrstaProizvoda vrstaProizvoda) {
                    return DropdownMenuItem<VrstaProizvoda>(
                      value: vrstaProizvoda,
                      child: Text(vrstaProizvoda.naziv ?? ''),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Type'),
                  dropdownColor: const Color.fromRGBO(227, 232, 247, 1),
                ),
                const SizedBox(height: 20),
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
                        final name = nameController.text;
                        final code = codeController.text;
                        final price = priceController.text;
                        final description = descriptionController.text;
                        // final image = imageController.text;
                        VrstaProizvoda vrstaProizvoda = selectedVrstaProizvoda;

                        widget.onUpdatePressed(_proizvodToEdit!.proizvodID!, {
                          'naziv': name,
                          'sifra': code,
                          'cijena': price,
                          'opis': description,
                          // 'slika': image,
                          vrstaProizvoda: vrstaProizvoda,
                        });

                        Navigator.pop(context);
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
