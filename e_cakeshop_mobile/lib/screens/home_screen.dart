import 'package:e_cakeshop_mobile/main.dart';
import 'package:e_cakeshop_mobile/models/novost.dart';
import 'package:e_cakeshop_mobile/models/proizvod.dart';
import 'package:e_cakeshop_mobile/providers/cart_provider.dart';
import 'package:e_cakeshop_mobile/providers/novost_provider.dart';
import 'package:e_cakeshop_mobile/providers/proizvod_provider.dart';
import 'package:e_cakeshop_mobile/screens/cart_screen.dart';
import 'package:e_cakeshop_mobile/screens/map_screen.dart';
import 'package:e_cakeshop_mobile/screens/review_screen.dart';
import 'package:e_cakeshop_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Proizvod> products = [];
  List<Proizvod> filteredProducts = [];
  List<Novost> news = [];
  List<Novost> filteredNews = [];
  bool showProducts = false;
  bool showNews = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
      ),
      body: Container(
        color: const Color.fromRGBO(222, 235, 251, 1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color.fromRGBO(247, 249, 253, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(247, 249, 253, 1),
                      hintText: 'Search...',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                    ),
                    onChanged: (value) {
                      if (showProducts) {
                        _searchProducts(value);
                      } else if (showNews) {
                        _searchNews(value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Hi, ',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    Authorization.korisnik?.ime ?? 'Guest',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'What do you want to eat today?',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(160, 40),
                      backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
                    ),
                    onPressed: () async {
                      await _loadProducts();
                      _searchProducts('');
                      setState(() {
                        showProducts = true;
                        showNews = false;
                      });
                    },
                    child: const Text('Menu',
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(160, 40),
                      backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
                    ),
                    onPressed: () async {
                      await _loadNews();
                      _searchNews('');
                      setState(() {
                        showProducts = false;
                        showNews = true;
                      });
                    },
                    child: const Text('News',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (showProducts)
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color.fromRGBO(247, 249, 253, 1),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImage(
                              filteredProducts[index].slika,
                              imageSize: 80,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredProducts[index].naziv ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${filteredProducts[index].cijena} KM',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      _showProductDetailsDialog(
                                          context, filteredProducts[index]);
                                    },
                                    child: const Text(
                                      'Tap for more details',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              if (showNews)
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredNews.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color.fromRGBO(247, 249, 253, 1),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImage(
                              filteredNews[index].thumbnail,
                              imageSize: 80,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredNews[index].naslov ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      _showNewsDetailsDialog(
                                          context, filteredNews[index]);
                                    },
                                    child: const Text(
                                      'Tap for more details',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
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
                Navigator.pushNamed(context, MapScreen.routeName);
              },
              icon: const Icon(Icons.map),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, ReviewScreen.routeName);
              },
              icon: const Icon(Icons.star),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (_) => false,
                );
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl, {double imageSize = 50}) {
    return Container(
      width: imageSize,
      height: imageSize,
      child: imageUrl != null
          ? Image.memory(
              dataFromBase64String(imageUrl),
              fit: BoxFit.cover,
            )
          : const Text('No Image'),
    );
  }

  void _showProductDetailsDialog(BuildContext context, Proizvod product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              product.naziv ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: _buildImage(product.slika),
                ),
              ),
              const SizedBox(height: 20),
              Text(product.opis ?? ''),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey,
              ),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .addToCart(product);
                Navigator.of(context).pop();
                Navigator.pushNamed(context, CartScreen.routeName);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
              ),
              child: const Text('Add to Cart'),
            ),
          ],
        );
      },
    );
  }

  void _showNewsDetailsDialog(BuildContext context, Novost novost) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              novost.naslov ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: _buildImage(novost.thumbnail),
                ),
              ),
              const SizedBox(height: 20),
              Text(novost.opis ?? ''),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey,
              ),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadProducts() async {
    try {
      ProizvodProvider proizvodProvider = ProizvodProvider();
      List<Proizvod> fetchedProducts = await proizvodProvider.Get();
      setState(() {
        products = fetchedProducts;
        filteredProducts = List.from(products);
        showProducts = true;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> _loadNews() async {
    try {
      NovostProvider novostProvider = NovostProvider();
      List<Novost> fetchedNews = await novostProvider.Get();
      setState(() {
        news = fetchedNews;
        filteredNews = List.from(news);
        showNews = true;
      });
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  void _searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = List.from(products);
      } else {
        filteredProducts = products
            .where((product) =>
                product.naziv?.toLowerCase().contains(query.toLowerCase()) ??
                false)
            .toList();
      }
    });
  }

  void _searchNews(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredNews = List.from(news);
      } else {
        filteredNews = news
            .where((news) =>
                news.naslov?.toLowerCase().contains(query.toLowerCase()) ??
                false)
            .toList();
      }
    });
  }
}
