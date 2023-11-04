import 'package:e_cakeshop/desktop/ui/archive_screen.dart';
import 'package:e_cakeshop/desktop/ui/news_screen.dart';
import 'package:e_cakeshop/desktop/ui/orders_screen.dart';
import 'package:e_cakeshop/desktop/ui/pictures_screen.dart';
import 'package:e_cakeshop/desktop/ui/product_screen.dart';
import 'package:e_cakeshop/desktop/ui/user_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedNavItem = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double leftContainerWidth = screenWidth * 0.2;
    double rightContainerWidth = screenWidth - leftContainerWidth - 30.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('eCakeShop'),
        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
      ),
      backgroundColor: const Color.fromRGBO(222, 235, 251, 1),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: leftContainerWidth,
            margin: const EdgeInsets.fromLTRB(10, 20, 0, 20),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(247, 249, 253, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  ClipOval(
                    child: Image.asset(
                      'lib/assets/images/logo.jpg',
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
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
                    title: 'Pictures',
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
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: rightContainerWidth,
            margin: const EdgeInsets.fromLTRB(0, 20, 10, 20),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(247, 249, 253, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _buildSelectedContent(),
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
      case 'Pictures':
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
