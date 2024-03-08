// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, unnecessary_null_comparison

import 'package:e_cakeshop_admin/models/recenzija.dart';

import 'package:flutter/material.dart';

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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController contentController = TextEditingController();
  late Recenzija? _recenzijaToEdit;
  double _rating = 3.0;

  void editReview() async {
    try {
      final content = contentController.text;

      int? convertedRating;
      if (_rating != null) {
        convertedRating = _rating.toInt();
      }

      widget.onUpdatePressed(
        _recenzijaToEdit!.recenzijaID!,
        {
          "sadrzajRecenzije": content,
          "ocjena": convertedRating,
          "datumKreiranja": _recenzijaToEdit!.datumKreiranja!.toIso8601String(),
          "korisnikID": _recenzijaToEdit!.korisnikID,
        },
      );

      Navigator.pop(context);
      setState(() {});
    } catch (e) {
      print("Error!");
    }
  }

  @override
  void initState() {
    super.initState();
    _recenzijaToEdit = widget.recenzijaToEdit;

    if (_recenzijaToEdit != null) {
      contentController.text = _recenzijaToEdit!.sadrzajRecenzije ?? '';
      _rating = _recenzijaToEdit!.ocjena?.toDouble() ?? 3.0;
    }
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
              child: Form(
                key: _formKey,
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
                    TextFormField(
                      controller: contentController,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        hintText: 'Example: This cake is delicious!',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter news content';
                        }
                        return null;
                      },
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
                            if (_formKey.currentState!.validate()) {
                              editReview();
                            }
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
      ),
    );
  }
}
