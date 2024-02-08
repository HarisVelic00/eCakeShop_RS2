// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';

class EditProfileDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onEditPressed;
  final Map<String, dynamic> userData;

  const EditProfileDialog({
    required this.onEditPressed,
    required this.userData,
  });

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();

  Future<void> uploadEdit() async {
    try {
      final ime = nameController.text;
      final prezime = surnameController.text;
      final email = emailController.text;
      final telefon = telephoneController.text;

      if (ime.isEmpty || prezime.isEmpty || email.isEmpty || telefon.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ));
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

        if (!RegExp(r'^\d{3}-\d{3}-\d{3}$').hasMatch(telefon)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Invalid phone number format. Please use XXX-XXX-XXX'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (!RegExp(r'^[a-zA-Z]+$').hasMatch(ime) ||
            !RegExp(r'^[a-zA-Z]+$').hasMatch(prezime)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Name and surname should contain only letters'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        Map<String, dynamic> newEdit = {
          "ime": ime,
          "prezime": prezime,
          "email": email,
          "telefon": telefon
        };
        widget.onEditPressed(newEdit);
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
    nameController.text = widget.userData['name'];
    surnameController.text = widget.userData['surname'];
    emailController.text = widget.userData['email'];
    telephoneController.text = widget.userData['telephone'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(247, 249, 253, 1),
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: telephoneController,
              decoration: const InputDecoration(labelText: 'Telephone'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
          ),
          onPressed: uploadEdit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
