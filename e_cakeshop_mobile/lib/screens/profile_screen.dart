import 'package:e_cakeshop_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = "/profile";

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 80.0,
                backgroundImage: AssetImage('assets/images/profile_image.png'),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Authorization.korisnik?.ime ?? '',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    Authorization.korisnik?.prezime ?? '',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                Authorization.korisnik?.email ?? '',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(160, 40),
                      backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
                    ),
                    onPressed: () {
                      print('Edit Profile Button Pressed');
                    },
                    child: const Text('Edit Profile',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(160, 40),
                      backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
                    ),
                    onPressed: () {
                      print('Change Password Button Pressed');
                    },
                    child: const Text('Change Password',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
