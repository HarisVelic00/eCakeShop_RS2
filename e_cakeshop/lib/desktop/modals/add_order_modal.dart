import 'package:e_cakeshop/models/korisnik.dart';
import 'package:e_cakeshop/models/narudzbaproizvodi.dart';
import 'package:e_cakeshop/models/uplata.dart';
import 'package:e_cakeshop/providers/korisnik_provider.dart';
//import 'package:e_cakeshop/providers/narudzbaproizvodi_provider.dart';
import 'package:e_cakeshop/providers/uplata_provider.dart';
import 'package:flutter/material.dart';

class AddOrderModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final Function(Map<String, dynamic>) onAddOrderPressed;

  AddOrderModal(
      {required this.onCancelPressed, required this.onAddOrderPressed});

  @override
  _AddOrderModalState createState() => _AddOrderModalState();
}

class _AddOrderModalState extends State<AddOrderModal> {
  List<Korisnik> korisnikList = [];
  List<Uplata> uplataList = [];
  List<NarudzbaProizvodi> narudzbaProizvodiList = [];
  String? selectedKorisnik;
  String? selectedUplata;
  String? selectedNarudzba;

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
    loadData();
  }

  Future<void> loadData() async {
    try {
      korisnikList = await KorisnikProvider().Get();
      uplataList = await UplataProvider().Get();
      //narudzbaProizvodiList = await NarudzbaProizvodiProvider().Get();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
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
                dropdownColor: const Color.fromRGBO(227, 232, 247, 1),
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
                dropdownColor: const Color.fromRGBO(227, 232, 247, 1),
              ),
              DropdownButtonFormField<String>(
                value: selectedNarudzba,
                onChanged: (String? value) {
                  setState(() {
                    selectedNarudzba = value!;
                  });
                },
                items: narudzbaProizvodiList
                    .map((NarudzbaProizvodi narudzbaProizvodi) {
                  return DropdownMenuItem<String>(
                    value: narudzbaProizvodi.proizvod?.naziv ?? '',
                    child: Text(narudzbaProizvodi.proizvod?.naziv ?? ''),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Products'),
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
                        int korisnikID = findIdFromName(
                          selectedKorisnik,
                          korisnikList,
                          (Korisnik korisnik) => korisnik.ime ?? '',
                          (Korisnik korisnik) => korisnik.korisnikID ?? -1,
                        );
                        int uplataID = findIdFromName(
                          selectedUplata,
                          uplataList,
                          (Uplata uplata) => uplata.brojTransakcije ?? '',
                          (Uplata uplata) => uplata.uplataID ?? -1,
                        );
                        // int narudzbaProizvodID = findIdFromName(
                        //   selectedNarudzba,
                        //   narudzbaProizvodiList,
                        //   (NarudzbaProizvodi narudzbaProizvodi) =>
                        //       narudzbaProizvodi.proizvod?.naziv ?? '',
                        //   (NarudzbaProizvodi narudzbaProizvodi) =>
                        //       narudzbaProizvodi.proizvodID ?? -1,
                        // );

                        if (korisnikID != -1 &&
                                uplataID !=
                                    -1 /*&&
                            narudzbaProizvodID != -1*/
                            ) {
                          Map<String, dynamic> newOrder = {
                            "korisnikID": korisnikID,
                            "uplataID": uplataID,
                            //"listaProizvoda": [narudzbaProizvodID]
                          };

                          widget.onAddOrderPressed(newOrder);
                          setState(() {});
                        } else {
                          print("Error: Some selected values are not set");
                        }
                      } catch (e) {
                        print("Error adding user: $e");
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
