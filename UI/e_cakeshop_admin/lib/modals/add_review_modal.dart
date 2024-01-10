// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print
import 'package:e_cakeshop_admin/models/korisnik.dart';
import 'package:e_cakeshop_admin/providers/korisnik_provider.dart';
import 'package:flutter/material.dart';

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
  String? selectedKorisnik;
  List<Korisnik> korisnikList = [];
  double _rating = 3.0;

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
    int convertedRating = _rating.toInt();

    int korisnikID = korisnikList
            .firstWhere((korisnik) => korisnik.ime == selectedKorisnik)
            .korisnikID ??
        -1;

    Map<String, dynamic> newReview = {
      "sadrzajRecenzije": content,
      "ocjena": convertedRating,
      "datumKreiranja": DateTime.now().toIso8601String(),
      "korisnikID": korisnikID,
    };
    widget.onAddReviewPressed(newReview);
    Navigator.pop(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          child: Container(
            color: const Color.fromRGBO(247, 249, 253, 1),
            width: MediaQuery.of(context).size.width * 0.2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Add Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(labelText: 'Content'),
                  ),
                  const SizedBox(height: 20),
                  const Text('Rating'),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color.fromRGBO(97, 142, 246, 1),
                      inactiveTrackColor:
                          const Color.fromRGBO(97, 142, 246, 0.3),
                      thumbColor: Colors.blueAccent,
                      valueIndicatorColor:
                          const Color.fromRGBO(97, 142, 246, 1),
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
                  const SizedBox(height: 20),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(97, 142, 246, 1),
                        ),
                        onPressed: () {
                          uploadReview();
                        },
                        child: const Text('Add',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
