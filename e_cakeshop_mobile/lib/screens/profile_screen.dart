import 'package:e_cakeshop_mobile/main.dart';
import 'package:e_cakeshop_mobile/modals/edit_profile_modal.dart';
import 'package:e_cakeshop_mobile/providers/korisnik_provider.dart';
import 'package:e_cakeshop_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = "/profile";
  final KorisnikProvider korisnikProvider = KorisnikProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> updateUser(
      BuildContext context, int id, Map<String, dynamic> request) async {
    try {
      var updatedUser = await korisnikProvider.update(id, request);
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
                          context,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
            );
          },
          label: const Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          icon: const Icon(Icons.logout, color: Colors.white),
          backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
        ),
      ),
    );
  }
}
