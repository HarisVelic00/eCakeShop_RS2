// ignore_for_file: unused_field, unused_local_variable, avoid_print, use_key_in_widget_constructors, use_build_context_synchronously, library_private_types_in_public_api

import 'package:e_cakeshop_mobile/modals/edit_profile_modal.dart';
import 'package:e_cakeshop_mobile/providers/korisnik_provider.dart';
import 'package:e_cakeshop_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "/profile";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const String routeName = "/profile";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final KorisnikProvider korisnikProvider = KorisnikProvider();

  Future<void> updateUser(int id, Map<String, dynamic> request) async {
    try {
      var updatedUser = await korisnikProvider.updateMobile(id, request);
      setState(() {
        Authorization.korisnik = updatedUser;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User updated successfully'),
        ),
      );
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(222, 235, 251, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipOval(
                child: Image.asset(
                  'lib/assets/images/logo.jpg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(247, 249, 253, 1),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20.0),
                    Text(
                      Authorization.korisnik?.ime ?? '',
                      style: const TextStyle(
                        fontSize: 40.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      Authorization.korisnik?.prezime ?? '',
                      style: const TextStyle(
                        fontSize: 40.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      Authorization.korisnik?.email ?? '',
                      style: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      Authorization.korisnik?.telefon.toString() ?? '',
                      style: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(160, 40),
                backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EditProfileDialog(
                      onEditPressed: (Map<String, dynamic> newEdit) {
                        updateUser(
                          Authorization.korisnik?.korisnikID ?? 0,
                          newEdit,
                        );
                      },
                    );
                  },
                );
              },
              child: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
