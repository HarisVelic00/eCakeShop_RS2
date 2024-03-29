// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print

import 'package:e_cakeshop_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class AddReviewModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddReviewPressed;

  const AddReviewModal({required this.onAddReviewPressed});

  @override
  _AddReviewDialogState createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewModal> {
  final TextEditingController contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _rating = 3.0;

  Future<void> uploadReview() async {
    try {
      final content = contentController.text;
      int convertedRating = _rating.toInt();

      Map<String, dynamic> newReview = {
        "sadrzajRecenzije": content,
        "ocjena": convertedRating,
        "datumKreiranja": DateTime.now().toIso8601String(),
        "korisnikID": Authorization.korisnik?.korisnikID,
      };

      widget.onAddReviewPressed(newReview);
      setState(() {});
    } catch (e) {
      print("Error uploading review: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(247, 249, 253, 1),
      title: const Text('Add Review'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  hintText: 'Example: This cake is delicious!',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Rating'),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color.fromRGBO(97, 142, 246, 1),
                  inactiveTrackColor: const Color.fromRGBO(97, 142, 246, 0.3),
                  thumbColor: Colors.blueAccent,
                  valueIndicatorColor: const Color.fromRGBO(97, 142, 246, 1),
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
            ],
          ),
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
            if (_formKey.currentState!.validate()) {
              uploadReview();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
