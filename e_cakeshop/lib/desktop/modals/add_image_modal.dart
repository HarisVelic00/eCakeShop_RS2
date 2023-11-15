import 'package:e_cakeshop/models/korisnik.dart';
import 'package:e_cakeshop/providers/korisnik_provider.dart';
import 'package:flutter/material.dart';

class AddImageModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final Function(Map<String, dynamic>) onAddSlikaPressed;

  AddImageModal(
      {required this.onCancelPressed, required this.onAddSlikaPressed});

  @override
  _AddImageModalState createState() => _AddImageModalState();
}

class _AddImageModalState extends State<AddImageModal> {
  final TextEditingController imageByteController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<Korisnik> korisnikList = [];
  String? selectedKorisnik;

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

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: const Color.fromRGBO(227, 232, 247, 1),
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
              TextField(
                controller: imageByteController,
                decoration: const InputDecoration(labelText: 'Image'),
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
                    onPressed: () {
                      try {
                        final slika = imageByteController.text;
                        final opis = descriptionController.text;

                        if (slika.isEmpty ||
                            opis.isEmpty ||
                            selectedKorisnik == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          int korisnikID = findIdFromName(
                            selectedKorisnik,
                            korisnikList,
                            (Korisnik korisnik) => korisnik.ime ?? '',
                            (Korisnik korisnik) => korisnik.korisnikID ?? -1,
                          );

                          if (korisnikID != -1) {
                            Map<String, dynamic> newSlika = {
                              "slika": slika,
                              "opis": opis,
                              "korisnikID": korisnikID,
                            };

                            widget.onAddSlikaPressed(newSlika);
                            setState(() {});
                          } else {
                            print("Error: Some selected values are not set");
                          }
                        }
                      } catch (e) {
                        print("Error adding image: $e");
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
    );
  }
}
