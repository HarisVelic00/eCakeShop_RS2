// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print

import 'package:e_cakeshop/models/korisnik.dart';
import 'package:e_cakeshop/providers/korisnik_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddReviewModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final Function(Map<String, dynamic>) onAddReviewPressed;

  const AddReviewModal(
      {required this.onCancelPressed, required this.onAddReviewPressed});

  @override
  _AddReviewModalState createState() => _AddReviewModalState();
}

class _AddReviewModalState extends State<AddReviewModal> {
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? selectedKorisnik;
  List<Korisnik> korisnikList = [];
  double _rating = 3.0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      korisnikList = await KorisnikProvider().Get();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> uploadReview() async {
    final content = contentController.text;
    final date = dateController.text;
    DateTime tempDate = DateFormat("dd-MM-yyyy").parse(date);
    int convertedRating = _rating.toInt();

    int korisnikID = korisnikList
            .firstWhere((korisnik) => korisnik.ime == selectedKorisnik)
            .korisnikID ??
        -1;

    Map<String, dynamic> newReview = {
      "sadrzajRecenzije": content,
      "ocjena": convertedRating,
      "datumKreiranja": tempDate.toIso8601String(),
      "korisnikID": korisnikID,
    };
    widget.onAddReviewPressed(newReview);
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(247, 249, 253, 1),
      title: const Text('Add Review'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Review Content'),
            ),
            const SizedBox(height: 20),
            const Text('Rating'),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color.fromRGBO(97, 142, 246, 1),
                inactiveTrackColor: const Color.fromRGBO(97, 142, 246, 0.3),
                thumbColor: Colors.blueAccent,
              ),
              child: Slider(
                value: _rating,
                min: 1,
                max: 5,
                divisions: 4,
                label: _rating.toString(),
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date of Creation',
                hintText: 'YYYY-MM-DD',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            DropdownButtonFormField<String>(
              value: selectedKorisnik,
              onChanged: (String? value) {
                setState(() {
                  selectedKorisnik = value!;
                });
              },
              items: korisnikList.map((Korisnik korisnik) {
                return DropdownMenuItem<String>(
                  value: korisnik.ime ?? '',
                  child: Text(korisnik.ime ?? ''),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'User'),
              dropdownColor: const Color.fromRGBO(247, 249, 253, 1),
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
          onPressed: () {
            uploadReview();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
