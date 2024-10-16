import 'package:flutter/material.dart';
import 'package:seller_app/SCREENS/appeal_screen.dart';

class DisabledAccountDialog extends StatelessWidget {
  const DisabledAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Your account has been disabled'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Please contact the administrator for further assistance.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Appeal'),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AppealScreen()));
          },
        ),
      ],
    );
  }
}

void showDisabledDialogue(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return DisabledAccountDialog();
    },
  );
}