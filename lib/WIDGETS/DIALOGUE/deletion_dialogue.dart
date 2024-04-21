import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GetDeletionDialogue extends StatelessWidget {
  final String mainText;

  const GetDeletionDialogue({
    super.key,
    required this.mainText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20), // Adjust the border radius here
      ),
      title: const Text("Confirm Deletion"),
      content: Text(
        mainText,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.red[400]),
          ),
        ),
      ],
    );
  }
}

Future<bool> showDeletionDialogue({
  required BuildContext context,
  required String text,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return GetDeletionDialogue(mainText: text);
    },
  );
}
