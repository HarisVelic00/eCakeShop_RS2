// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, avoid_print

import 'package:e_cakeshop_mobile/modals/add_review_modal.dart';
import 'package:flutter/material.dart';
import 'package:e_cakeshop_mobile/models/recenzija.dart';
import 'package:e_cakeshop_mobile/providers/recenzija_provider.dart';
import 'package:intl/intl.dart';

class ReviewScreen extends StatefulWidget {
  static const String routeName = "/review";

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<Recenzija> recenzijaList = [];
  final recenzijaProvider = RecenzijaProvider();

  @override
  void initState() {
    super.initState();
    loadRecenzije();
  }

  Future<void> loadRecenzije() async {
    try {
      recenzijaList = await RecenzijaProvider().Get({'includeKorisnik': true});
      setState(() {});
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void addNewReview(Map<String, dynamic> newReview) async {
    try {
      await recenzijaProvider.insert(newReview);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review added successfully'),
        ),
      );
      await loadRecenzije();
      Navigator.pop(context);
    } catch (e) {
      print("Error adding review: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add review'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reviews',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(222, 235, 251, 1),
        child: recenzijaList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: recenzijaList.length,
                itemBuilder: (context, index) {
                  Recenzija recenzija = recenzijaList[index];
                  return Container(
                    color: const Color.fromRGBO(247, 249, 253, 1),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        recenzija.korisnik?.ime ?? '',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            recenzija.datumKreiranja != null
                                ? DateFormat.yMMMd()
                                    .format(recenzija.datumKreiranja!)
                                : '',
                          ),
                          const SizedBox(height: 10),
                          Text(
                            recenzija.sadrzajRecenzije ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: List.generate(
                              recenzija.ocjena ?? 0,
                              (index) =>
                                  const Icon(Icons.star, color: Colors.amber),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(97, 142, 246, 1),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddReviewModal(
                onAddReviewPressed: (Map<String, dynamic> newReview) {
                  addNewReview(newReview);
                },
              );
            },
          );
        },
        child: const Icon(Icons.rate_review, color: Colors.white),
      ),
    );
  }
}
