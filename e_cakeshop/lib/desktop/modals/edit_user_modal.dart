import 'package:e_cakeshop/models/drzava.dart';
import 'package:e_cakeshop/models/grad.dart';
import 'package:e_cakeshop/models/korisnik.dart';
import 'package:e_cakeshop/models/uloga.dart';
import 'package:e_cakeshop/providers/drzava_provider.dart';
import 'package:e_cakeshop/providers/grad_provider.dart';
import 'package:e_cakeshop/providers/uloga_provider.dart';
import 'package:flutter/material.dart';

class EditUserModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Korisnik? korisnikToEdit;

  EditUserModal({
    required this.onCancelPressed,
    required this.onUpdatePressed,
    required this.korisnikToEdit,
  });

  @override
  _EditUserModalState createState() => _EditUserModalState();
}

class _EditUserModalState extends State<EditUserModal> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  late Korisnik? _korisnikToEdit;
  List<Grad> gradList = [];
  List<Drzava> drzavaList = [];
  List<Uloga> ulogaList = [];
  String? selectedGrad;
  String? selectedDrzava;
  String? selectedUloga;

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
      gradList = await GradProvider().Get();
      drzavaList = await DrzavaProvider().Get();
      ulogaList = await UlogaProvider().Get();
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
    _korisnikToEdit = widget.korisnikToEdit;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: Color.fromRGBO(227, 232, 247, 1),
        width: MediaQuery.of(context).size.width * 0.2,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Edit User',
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
                  controller: surnameController,
                  decoration: const InputDecoration(labelText: 'Surname'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: telephoneController,
                  decoration: const InputDecoration(labelText: 'Telephone'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedGrad,
                  onChanged: (String? value) {
                    setState(() {
                      selectedGrad = value!;
                    });
                  },
                  items: gradList.map((Grad grad) {
                    return DropdownMenuItem<String>(
                      value: grad.naziv,
                      child: Text(grad.naziv ?? ''),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'City'),
                  dropdownColor: const Color.fromRGBO(227, 232, 247, 1),
                ),
                DropdownButtonFormField<String>(
                  value: selectedDrzava,
                  onChanged: (String? value) {
                    setState(() {
                      selectedDrzava = value!;
                    });
                  },
                  items: drzavaList.map((Drzava drzava) {
                    return DropdownMenuItem<String>(
                      value: drzava.naziv,
                      child: Text(drzava.naziv ?? ''),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Country'),
                  dropdownColor: const Color.fromRGBO(227, 232, 247, 1),
                ),
                TextField(
                  controller: roleController,
                  decoration: const InputDecoration(labelText: 'Uloga'),
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
                        final surname = surnameController.text;
                        final email = emailController.text;
                        final telephone = telephoneController.text;
                        final role = roleController.text;

                        int gradID = findIdFromName(
                          selectedGrad,
                          gradList,
                          (Grad grad) => grad.naziv ?? '',
                          (Grad grad) => grad.gradID ?? -1,
                        );
                        int drzavaID = findIdFromName(
                          selectedDrzava,
                          drzavaList,
                          (Drzava drzava) => drzava.naziv ?? '',
                          (Drzava drzava) => drzava.drzavaID ?? -1,
                        );

                        widget.onUpdatePressed(_korisnikToEdit!.korisnikID!, {
                          'ime': name,
                          'prezime': surname,
                          'email': email,
                          'telefon': telephone,
                          "gradID": gradID,
                          "drzavaID": drzavaID,
                          'uloga': role,
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
