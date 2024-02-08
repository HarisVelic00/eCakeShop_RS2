// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print
import 'package:e_cakeshop_admin/models/drzava.dart';
import 'package:e_cakeshop_admin/models/grad.dart';
import 'package:e_cakeshop_admin/models/korisnik.dart';
import 'package:e_cakeshop_admin/providers/drzava_provider.dart';
import 'package:e_cakeshop_admin/providers/grad_provider.dart';
import 'package:flutter/material.dart';

class EditUserModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Korisnik? korisnikToEdit;

  const EditUserModal({
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

  late Korisnik? _korisnikToEdit;
  List<Grad> gradList = [];
  List<Drzava> drzavaList = [];
  String? selectedGrad;
  String? selectedDrzava;
  Map<String, String> gradToDrzavaMap = {};

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
      gradToDrzavaMap = await loadGradDrzavaMapping();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<Map<String, String>> loadGradDrzavaMapping() async {
    Map<String, String> mapping = {
      'Sarajevo': 'Bosna i Hercegovina',
      'Beograd': 'Srbija',
      'Zagreb': 'Hrvatska',
    };
    Set<String> uniqueCountries = mapping.values.toSet();
    return {
      for (var country in uniqueCountries)
        mapping.entries.firstWhere((entry) => entry.value == country).key:
            country
    };
  }

  Future<void> _editUser() async {
    try {
      final name = nameController.text;
      final surname = surnameController.text;
      final email = emailController.text;
      final telephone = telephoneController.text;

      if (name.isEmpty ||
          surname.isEmpty ||
          email.isEmpty ||
          telephone.isEmpty ||
          selectedGrad == null ||
          selectedDrzava == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all fields'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
            .hasMatch(email)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email format'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (!RegExp(r'^\d{3}-\d{3}-\d{3}$').hasMatch(telephone)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Invalid phone number format. Please use XXX-XXX-XXX'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(name) ||
            !RegExp(r'^[a-zA-Z]+$').hasMatch(surname)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Name and surname should contain only letters'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

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
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error editing user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error editing user'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _korisnikToEdit = widget.korisnikToEdit;

    if (_korisnikToEdit != null) {
      nameController.text = _korisnikToEdit!.ime ?? '';
      surnameController.text = _korisnikToEdit!.prezime ?? '';
      emailController.text = _korisnikToEdit!.email ?? '';
      telephoneController.text = _korisnikToEdit!.telefon ?? '';
      selectedGrad = _korisnikToEdit!.grad?.naziv;
      selectedDrzava = _korisnikToEdit!.drzava?.naziv;
    }

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
                    'Edit User',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Example John',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextField(
                    controller: surnameController,
                    decoration: const InputDecoration(
                      labelText: 'Surname',
                      hintText: 'Example Smith',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'example@email.com',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextField(
                    controller: telephoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telephone',
                      hintText: 'Example 037-123-456',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedDrzava,
                    onChanged: (String? value) {
                      setState(() {
                        selectedDrzava = value!;
                        selectedGrad = null;
                      });
                    },
                    items: drzavaList
                        .map((Drzava drzava) => drzava.naziv ?? '')
                        .toSet()
                        .map((String country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    decoration: const InputDecoration(labelText: 'Country'),
                    dropdownColor: const Color.fromRGBO(247, 249, 253, 1),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedGrad,
                    onChanged: (String? value) {
                      setState(() {
                        selectedGrad = value!;
                      });
                    },
                    items: gradList
                        .where((Grad grad) =>
                            gradToDrzavaMap[grad.naziv] == selectedDrzava)
                        .map((Grad grad) {
                      return DropdownMenuItem<String>(
                        value: grad.naziv,
                        child: Text(grad.naziv ?? ''),
                      );
                    }).toList(),
                    decoration: const InputDecoration(labelText: 'City'),
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
                        onPressed: _editUser,
                        child: const Text('Save',
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
