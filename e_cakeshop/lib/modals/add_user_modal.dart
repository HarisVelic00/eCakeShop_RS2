import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_cakeshop/models/drzava.dart';
import 'package:e_cakeshop/models/grad.dart';
import 'package:e_cakeshop/models/uloga.dart';
import 'package:e_cakeshop/providers/drzava_provider.dart';
import 'package:e_cakeshop/providers/grad_provider.dart';
import 'package:e_cakeshop/providers/uloga_provider.dart';

class AddUserModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final Function(Map<String, dynamic>) onAddUserPressed;

  AddUserModal({
    required this.onCancelPressed,
    required this.onAddUserPressed,
  });

  @override
  _AddUserModalState createState() => _AddUserModalState();
}

class _AddUserModalState extends State<AddUserModal> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<Grad> gradList = [];
  List<Drzava> drzavaList = [];
  List<Uloga> ulogaList = [];
  String? selectedGrad;
  String? selectedDrzava;
  String? selectedUloga;

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

  Future<void> _uploadUser() async {
    try {
      final name = nameController.text;
      final surname = surnameController.text;
      final username = usernameController.text;
      final dob = dobController.text;
      final email = emailController.text;
      final telephone = telephoneController.text;
      final password = passwordController.text;

      if (name.isEmpty ||
          surname.isEmpty ||
          username.isEmpty ||
          dob.isEmpty ||
          email.isEmpty ||
          telephone.isEmpty ||
          selectedGrad == null ||
          selectedDrzava == null ||
          selectedUloga == null ||
          password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all fields'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        DateTime tempDate = DateFormat("dd-MM-yyyy").parse(dob);

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
        int ulogaID = findIdFromName(
          selectedUloga,
          ulogaList,
          (Uloga uloga) => uloga.naziv ?? '',
          (Uloga uloga) => uloga.ulogaID ?? -1,
        );

        if (gradID != -1 && drzavaID != -1 && ulogaID != -1) {
          Map<String, dynamic> newUser = {
            "ime": name,
            "prezime": surname,
            "datumRodjenja": tempDate.toIso8601String(),
            "korisnickoIme": username,
            "email": email,
            "telefon": telephone,
            "gradID": gradID,
            "drzavaID": drzavaID,
            "ulogeID": [ulogaID],
            "lozinka": password,
          };

          widget.onAddUserPressed(newUser);
          setState(() {});
        } else {
          print("Error: Some selected values are not set");
        }
      }
    } catch (e) {
      print("Error adding user: $e");
    }
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
                  'Add User',
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
                  controller: dobController,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    hintText: 'YYYY-MM-DD',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
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
                  dropdownColor: const Color.fromRGBO(247, 249, 253, 1),
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
                  dropdownColor: const Color.fromRGBO(247, 249, 253, 1),
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: selectedUloga,
                  onChanged: (String? value) {
                    setState(() {
                      selectedUloga = value!;
                    });
                  },
                  items: ulogaList.map((Uloga uloga) {
                    return DropdownMenuItem<String>(
                      value: uloga.naziv,
                      child: Text(uloga.naziv ?? ''),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Uloga'),
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
                        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
                      ),
                      onPressed: _uploadUser,
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
