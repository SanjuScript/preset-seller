import 'package:flutter/material.dart';
import 'package:seller_app/DATA/admin_data.dart';
import 'package:seller_app/FUNCTIONS/admin_data_controller_unit.dart';
import 'package:seller_app/FUNCTIONS/profile_auth_functions.dart';

class ResetPasswordDialog extends StatelessWidget {
  final String emailAddress;

  const ResetPasswordDialog({super.key, required this.emailAddress});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('A password reset link will be sent to:'),
          const SizedBox(height: 8),
          Text(
            emailAddress,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            AuthController.resetpPassword(emailAddress);
          },
          child: const Text('Send Link'),
        ),
      ],
    );
  }
}

Future<bool> showResetPasswordDialogue({
  required BuildContext context,
  required String text,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return ResetPasswordDialog(emailAddress: text);
    },
  );
}
