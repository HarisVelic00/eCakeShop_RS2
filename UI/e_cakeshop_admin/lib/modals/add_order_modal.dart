// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, library_private_types_in_public_api, prefer_const_constructors_in_immutables, non_constant_identifier_names, avoid_print
import 'package:e_cakeshop_admin/models/korisnik.dart';
import 'package:e_cakeshop_admin/models/proizvod.dart';
import 'package:e_cakeshop_admin/models/uplata.dart';
import 'package:e_cakeshop_admin/providers/korisnik_provider.dart';
import 'package:e_cakeshop_admin/providers/proizvod_provider.dart';
import 'package:e_cakeshop_admin/providers/uplata_provider.dart';
import 'package:flutter/material.dart';

class MultiDropdownCheckbox extends StatefulWidget {
  final List<Proizvod> products;
  final Function(List<Map<String, dynamic>>) onSelectionChanged;

  const MultiDropdownCheckbox({
    required this.products,
    required this.onSelectionChanged,
  });

  @override
  _MultiDropdownCheckboxState createState() => _MultiDropdownCheckboxState();
}

class _MultiDropdownCheckboxState extends State<MultiDropdownCheckbox> {
  Map<int, int> _selectedProducts = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Products'),
        Wrap(
          children: widget.products.map((proizvod) {
            final proizvodID = proizvod.proizvodID ?? -1;
            return Row(
              children: [
                Checkbox(
                  value: _selectedProducts.containsKey(proizvodID),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null && value) {
                        _selectedProducts[proizvodID] = 1;
                      } else {
                        _selectedProducts.remove(proizvodID);
                      }
                      widget.onSelectionChanged(
                        _selectedProducts.entries
                            .map((entry) => {
                                  'proizvodID': entry.key,
                                  'kolicina': entry.value,
                                })
                            .toList(),
                      );
                    });
                  },
                ),
                Text(proizvod.naziv ?? ''),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: _selectedProducts[proizvodID] ?? 1,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedProducts[proizvodID] = value!;
                      widget.onSelectionChanged(
                        _selectedProducts.entries
                            .map((entry) => {
                                  'proizvodID': entry.key,
                                  'kolicina': entry.value,
                                })
                            .toList(),
                      );
                    });
                  },
                  items: List.generate(
                    10,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text((index + 1).toString()),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class AddOrderModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final Function(Map<String, dynamic>) onAddOrderPressed;

  AddOrderModal({
    required this.onCancelPressed,
    required this.onAddOrderPressed,
  });

  @override
  _AddOrderModalState createState() => _AddOrderModalState();
}

class _AddOrderModalState extends State<AddOrderModal> {
  List<Korisnik> korisnikList = [];
  List<Uplata> uplataList = [];
  List<Proizvod> ProizvodiList = [];
  String? selectedKorisnik;
  String? selectedUplata;
  List<Map<String, dynamic>> selectedProducts = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      korisnikList = await KorisnikProvider().Get();
      uplataList = await UplataProvider().Get();
      ProizvodiList = await ProizvodProvider().Get();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _uploadOrder() async {
    try {
      int korisnikID = korisnikList
              .firstWhere((korisnik) => korisnik.ime == selectedKorisnik)
              .korisnikID ??
          -1;
      int uplataID = uplataList
              .firstWhere((uplata) => uplata.brojTransakcije == selectedUplata)
              .uplataID ??
          -1;

      if (korisnikID != -1 && uplataID != -1 && selectedProducts.isNotEmpty) {
        Map<String, dynamic> newOrder = {
          "korisnikID": korisnikID,
          "uplataID": uplataID,
          "listaProizvoda": selectedProducts,
        };

        widget.onAddOrderPressed(newOrder);
        Navigator.pop(context);
        setState(() {});
      } else {
        print("Error: Some selected values are not set");
      }
    } catch (e) {
      print("Error adding user: $e");
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
                  'Add Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
                DropdownButtonFormField<String>(
                  value: selectedUplata,
                  onChanged: (String? value) {
                    setState(() {
                      selectedUplata = value!;
                    });
                  },
                  items: uplataList.map((Uplata uplata) {
                    return DropdownMenuItem<String>(
                      value: uplata.brojTransakcije ?? '',
                      child: Text(uplata.brojTransakcije ?? ''),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Payment'),
                  dropdownColor: const Color.fromRGBO(247, 249, 253, 1),
                ),
                const SizedBox(height: 20),
                MultiDropdownCheckbox(
                  products: ProizvodiList,
                  onSelectionChanged: (selectedProducts) {
                    setState(() {
                      this.selectedProducts = selectedProducts;
                    });
                  },
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
                      onPressed: _uploadOrder,
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
