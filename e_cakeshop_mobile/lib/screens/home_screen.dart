import 'package:e_cakeshop_mobile/main.dart';
import 'package:e_cakeshop_mobile/screens/cart_screen.dart';
import 'package:e_cakeshop_mobile/screens/profile_screen.dart';
import 'package:e_cakeshop_mobile/screens/review_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Hi, Username',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'What do you want to eat today?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(160, 40),
                    backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
                  ),
                  onPressed: () {},
                  child: const Text('Menu'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(160, 40),
                    backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
                  ),
                  onPressed: () {},
                  child: const Text('News'),
                ),
              ],
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CartScreen.routeName);
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ReviewScreen.routeName);
                  },
                  icon: const Icon(Icons.star),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ProfileScreen.routeName);
                  },
                  icon: const Icon(Icons.person),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, LoginScreen.routeName);
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
