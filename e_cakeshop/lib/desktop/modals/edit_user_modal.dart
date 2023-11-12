import 'package:e_cakeshop/models/drzava.dart';
import 'package:e_cakeshop/models/grad.dart';
import 'package:e_cakeshop/models/korisnik.dart';
import 'package:e_cakeshop/providers/drzava_provider.dart';
import 'package:e_cakeshop/providers/grad_provider.dart';
import 'package:flutter/material.dart';

class EditUserModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final VoidCallback onSavePressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Korisnik? korisnikToEdit;

  EditUserModal({
    required this.onCancelPressed,
    required this.onSavePressed,
    required this.onUpdatePressed,
    required this.korisnikToEdit,
  });

  @override
  _EditUserModalState createState() => _EditUserModalState();
}

class _EditUserModalState extends State<EditUserModal> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();

  late Korisnik? _korisnikToEdit;
  Grad? selectedCity;
  Drzava? selectedCountry;
  List<Grad> gradList = [];
  List<Drzava> drzavaList = [];

  Grad selectedGrad = Grad();
  Drzava selectedDrzava = Drzava();

  Future<void> fetchData() async {
    try {
      gradList = await GradProvider().Get();
      drzavaList = await DrzavaProvider().Get();
      if (gradList.isNotEmpty) {
        selectedGrad = gradList.first;
      }
      if (drzavaList.isNotEmpty) {
        selectedDrzava = drzavaList.first;
      }
      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _korisnikToEdit = widget.korisnikToEdit;
    fetchData();
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
                  'Edit User',
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
                  controller: surnameController,
                  decoration: const InputDecoration(labelText: 'Surname'),
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: dobController,
                  decoration: const InputDecoration(labelText: 'Date of Birth'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: telephoneController,
                  decoration: const InputDecoration(labelText: 'Telephone'),
                ),
                DropdownButtonFormField<Grad>(
                  value: selectedCity,
                  onChanged: (Grad? value) {
                    setState(() {
                      selectedCity = value;
                    });
                  },
                  items: gradList.map((Grad grad) {
                    return DropdownMenuItem<Grad>(
                      value: grad,
                      child: Text(grad.naziv ?? ''),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'City'),
                  dropdownColor: const Color.fromRGBO(227, 232, 247, 1),
                ),
                DropdownButtonFormField<Drzava>(
                  value: selectedCountry,
                  onChanged: (Drzava? value) {
                    setState(() {
                      selectedCountry = value;
                    });
                  },
                  items: drzavaList.map((Drzava drzava) {
                    return DropdownMenuItem<Drzava>(
                      value: drzava,
                      child: Text(drzava.naziv ?? ''),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Country'),
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
                        final surname = surnameController.text;
                        final username = usernameController.text;
                        final dob = dobController.text;
                        final email = emailController.text;
                        final telephone = telephoneController.text;
                        Grad grad = selectedGrad;
                        Drzava drzava = selectedDrzava;

                        widget.onUpdatePressed(_korisnikToEdit!.korisnikID!, {
                          'ime': name,
                          'prezime': surname,
                          'korisnickoIme': username,
                          'datumRodjenja': DateTime.parse(dob),
                          'email': email,
                          'telefon': telephone,
                          'grad': grad,
                          'drzava': drzava,
                        });

                        widget.onSavePressed();
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
