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
  final _formKey = GlobalKey<FormState>();
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
    final name = nameController.text;
    final surname = surnameController.text;
    final email = emailController.text;
    final telephone = telephoneController.text;

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
    if (_korisnikToEdit != null) {
      widget.onUpdatePressed(_korisnikToEdit!.korisnikID!, {
        'ime': name,
        'prezime': surname,
        'email': email,
        'telefon': telephone,
        "gradID": gradID,
        "drzavaID": drzavaID,
      });
      Navigator.pop(context);
    } else {
      print("Error!");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    super.dispose();
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
              child: Form(
                key: _formKey,
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
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Example: John',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Name can only contain letters';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: surnameController,
                      decoration: const InputDecoration(
                        labelText: 'Surname',
                        hintText: 'Example: Smith',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your surname';
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Surname can only contain letters';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'example@email.com',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                              .hasMatch(value)) {
                            return 'Invalid email format';
                          }
                          return null;
                        }),
                    TextFormField(
                      controller: telephoneController,
                      decoration: const InputDecoration(
                        labelText: 'Telephone',
                        hintText: 'Example: 037-123-456',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your telephone';
                        }
                        if (!RegExp(r'^\d{3}-\d{3}-\d{3}$').hasMatch(value)) {
                          return 'Invalid phone number format';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedDrzava,
                      onChanged: (String? value) {
                        setState(() {
                          selectedDrzava = value!;
                          selectedGrad = null;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a country';
                        }
                        return null;
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
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a city';
                        }
                        return null;
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _editUser();
                            }
                          },
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
      ),
    );
  }
}
