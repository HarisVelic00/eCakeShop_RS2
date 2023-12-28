import 'package:flutter/material.dart';

void showSuccessMessage(
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey, String message) {
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ),
  );
}

void showFailureMessage(
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey, String message) {
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}
