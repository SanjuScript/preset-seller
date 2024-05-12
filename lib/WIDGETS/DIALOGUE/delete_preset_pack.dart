import 'package:flutter/material.dart';

void showPresetpackDeletionDialog(BuildContext context,{required void Function() onTap}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirm Deletion"),
        content:
            const Text("Are you sure you want to delete this Preset Pack?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed:onTap,
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
