import 'package:e_cakeshop/models/korisnik.dart';
import 'package:e_cakeshop/providers/korisnik_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNewsModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final Function(Map<String, dynamic>) onAddNewsPressed;

  AddNewsModal({required this.onCancelPressed, required this.onAddNewsPressed});

  @override
  _AddNewsModalState createState() => _AddNewsModalState();
}

class _AddNewsModalState extends State<AddNewsModal> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController thumbnailController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

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
              TextField(
                controller: thumbnailController,
                decoration: const InputDecoration(labelText: 'Thumbnail'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Creation date',
                  hintText: 'YYYY-MM-DD',
                  hintStyle: TextStyle(color: Colors.grey),
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
                        final title = titleController.text;
                        final content = contentController.text;
                        final thumbnail = thumbnailController.text;
                        final date = dateController.text;

                        if (title.isEmpty ||
                            content.isEmpty ||
                            thumbnail.isEmpty ||
                            date.isEmpty ||
                            selectedKorisnik == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          DateTime tempDate =
                              DateFormat("yyyy-MM-dd").parse(date);

                          int korisnikID = findIdFromName(
                            selectedKorisnik,
                            korisnikList,
                            (Korisnik korisnik) => korisnik.ime ?? '',
                            (Korisnik korisnik) => korisnik.korisnikID ?? -1,
                          );

                          if (korisnikID != -1) {
                            Map<String, dynamic> newSlika = {
                              "naslov": title,
                              "sadrzaj": content,
                              "thumbnail": thumbnail,
                              "datumKreiranja": tempDate.toIso8601String(),
                              "korisnikID": korisnikID
                            };

                            widget.onAddNewsPressed(newSlika);
                            setState(() {});
                          } else {
                            print("Error: Selected user ID not found");
                          }
                        }
                      } catch (e) {
                        print("Error adding news: $e");
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
