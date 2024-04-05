import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerificationDialogue {
  static void showAccountCreatedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Account Created'),
          content: const Text('Your account has been created successfully. Please check your email for verification. After verifying your email, please login.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
