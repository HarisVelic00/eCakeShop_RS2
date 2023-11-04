import 'package:flutter/material.dart';

class DeleteModal extends StatelessWidget {
  final VoidCallback onDeletePressed;
  final VoidCallback onCancelPressed;

  DeleteModal({required this.onDeletePressed, required this.onCancelPressed});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dialogBackgroundColor: const Color.fromRGBO(227, 232, 247, 1),
      ),
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(24.0),
        title: const Column(
          children: [
            Center(
              child: Text(
                'Are you sure?',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'This field will be deleted',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                onPressed: onCancelPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: const Size(120, 48),
                ),
                child: const Text('Cancel'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ElevatedButton(
                onPressed: onDeletePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(120, 48),
                ),
                child: const Text('Delete'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
