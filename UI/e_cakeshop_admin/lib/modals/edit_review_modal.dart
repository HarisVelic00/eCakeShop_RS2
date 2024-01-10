// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print
import 'package:e_cakeshop_admin/models/korisnik.dart';
import 'package:e_cakeshop_admin/models/recenzija.dart';
import 'package:e_cakeshop_admin/providers/korisnik_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditReviewModal extends StatefulWidget {
  final VoidCallback onCancelPressed;
  final void Function(int, dynamic) onUpdatePressed;
  final Recenzija? recenzijaToEdit;

  const EditReviewModal({
    required this.onCancelPressed,
    required this.onUpdatePressed,
    required this.recenzijaToEdit,
  });

  @override
  _EditReviewModalState createState() => _EditReviewModalState();
}

class _EditReviewModalState extends State<EditReviewModal> {
  final TextEditingController contentController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  late Recenzija? _recenzijaToEdit;
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

  void editReview() async {
    final content = contentController.text;
    final date = dateController.text;
    int convertedRating = _rating.toInt();

    int korisnikID = korisnikList
            .firstWhere((korisnik) => korisnik.ime == selectedKorisnik)
            .korisnikID ??
        -1;

    DateTime tempDate = DateFormat("MM.dd.yyyy").parse(date);
    widget.onUpdatePressed(
      _recenzijaToEdit!.recenzijaID!,
      {
        "sadrzajRecenzije": content,
        "ocjena": convertedRating,
        "datumKreiranja": tempDate.toIso8601String(),
        "korisnikID": korisnikID,
      },
    );
    Navigator.pop(context);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _recenzijaToEdit = widget.recenzijaToEdit;

    if (_recenzijaToEdit != null) {
      contentController.text = _recenzijaToEdit!.sadrzajRecenzije ?? '';
      DateTime datumKreiranja = _recenzijaToEdit!.datumKreiranja!;
      String formattedDate = DateFormat('MM.dd.yyyy').format(datumKreiranja);
      dateController.text = formattedDate;

      selectedKorisnik = _recenzijaToEdit!.korisnik?.ime ?? '';
      _rating = _recenzijaToEdit!.ocjena?.toDouble() ?? 3.0;
    }

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
                    'Edit Review',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: contentController,
                    decoration:
                        const InputDecoration(labelText: 'Review Content'),
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
                  TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date of Creation',
                      hintText: 'MM.dd.yyyy',
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
                          editReview();
                        },
                        child: const Text('Save',
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
