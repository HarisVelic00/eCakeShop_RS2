// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables
import 'package:e_cakeshop_admin/main.dart';
import 'package:e_cakeshop_admin/screens/archive_screen.dart';
import 'package:e_cakeshop_admin/screens/images_screen.dart';
import 'package:e_cakeshop_admin/screens/news_screen.dart';
import 'package:e_cakeshop_admin/screens/orders_screen.dart';
import 'package:e_cakeshop_admin/screens/product_screen.dart';
import 'package:e_cakeshop_admin/screens/reviews_screen.dart';
import 'package:e_cakeshop_admin/screens/user_screen.dart';
import 'package:e_cakeshop_admin/utils/utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
  static const String routeName = "/home";
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedNavItem = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'eCakeShop',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
      ),
      backgroundColor: const Color.fromRGBO(222, 235, 251, 1),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 20, 0, 20),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(247, 249, 253, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Flexible(
                    child: ClipOval(
                      child: Image.asset(
                        'lib/assets/images/logo.jpg',
                        fit: BoxFit.cover,
                        height: 180,
                        width: 180,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    Authorization.korisnik?.ime ?? 'Guest',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        NavItem(
                          title: 'Users',
                          onTap: () {},
                          onSelect: (item) {
                            setState(() {
                              selectedNavItem = item;
                            });
                          },
                        ),
                        NavItem(
                          title: 'Products',
                          onTap: () {},
                          onSelect: (item) {
                            setState(() {
                              selectedNavItem = item;
                            });
                          },
                        ),
                        NavItem(
                          title: 'Orders',
                          onTap: () {},
                          onSelect: (item) {
                            setState(() {
                              selectedNavItem = item;
                            });
                          },
                        ),
                        NavItem(
                          title: 'Images',
                          onTap: () {},
                          onSelect: (item) {
                            setState(() {
                              selectedNavItem = item;
                            });
                          },
                        ),
                        NavItem(
                          title: 'News',
                          onTap: () {},
                          onSelect: (item) {
                            setState(() {
                              selectedNavItem = item;
                            });
                          },
                        ),
                        NavItem(
                          title: 'Archive',
                          onTap: () {},
                          onSelect: (item) {
                            setState(() {
                              selectedNavItem = item;
                            });
                          },
                        ),
                        NavItem(
                          title: 'Reviews',
                          onTap: () {},
                          onSelect: (item) {
                            setState(() {
                              selectedNavItem = item;
                            });
                          },
                        ),
                        NavItem(
                          title: 'Logout',
                          onTap: () {
                            Authorization.Username = '';
                            Authorization.Password = '';
                            Authorization.korisnik = null;

                            Navigator.of(context).pushNamedAndRemoveUntil(
                              LoginScreen.routeName,
                              (route) => false,
                            );
                          },
                          onSelect: (item) {
                            setState(() {
                              selectedNavItem = item;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 8,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 10, 20),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(247, 249, 253, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _buildSelectedContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedContent() {
    switch (selectedNavItem) {
      case 'Users':
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: UserScreen(),
        );
      case 'Products':
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ProductScreen(),
        );
      case 'Images':
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: PicturesScreen(),
        );
      case 'News':
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: NewsScreen(),
        );
      case 'Orders':
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: OrdersScreen(),
        );
      case 'Archive':
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ArchiveScreen(),
        );
      case 'Reviews':
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ReviewScreen(),
        );

      default:
        return const Center(
          child: Text('Select an item from the left navigation'),
        );
    }
  }
}

class NavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final Function(String) onSelect;
  NavItem({required this.title, required this.onTap, required this.onSelect});
  @override
  _NavItemState createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          widget.onSelect(widget.title);
          widget.onTap();
        },
        child: Container(
          color: isHovered
              ? const Color.fromRGBO(97, 142, 246, 1)
              : Colors.transparent,
          child: ListTile(
            title: Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
