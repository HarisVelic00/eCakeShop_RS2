// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class EditProfileDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onEditPressed;

  const EditProfileDialog({required this.onEditPressed});

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();

  Future<void> uploadEdit() async {
    final ime = nameController.text;
    final prezime = surnameController.text;
    final email = emailController.text;
    final telefon = telephoneController.text;

    Map<String, dynamic> newEdit = {
      "ime": ime,
      "prezime": prezime,
      "email": email,
      "telefon": telefon
    };
    widget.onEditPressed(newEdit);
    setState(() {});
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
