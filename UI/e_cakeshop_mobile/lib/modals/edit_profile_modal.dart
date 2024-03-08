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
  final _formKey = GlobalKey<FormState>();
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

      Map<String, dynamic> newEdit = {
        "ime": ime,
        "prezime": prezime,
        "email": email,
        "telefon": telefon
      };
      widget.onEditPressed(newEdit);
      Navigator.pop(context);
    } catch (e) {
      print('Error editing user: $e');
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
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
            ],
          ),
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              uploadEdit();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
