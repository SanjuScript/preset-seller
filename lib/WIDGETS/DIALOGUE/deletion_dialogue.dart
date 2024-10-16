import 'package:flutter/material.dart';
import 'package:seller_app/FUNCTIONS/admin_data_controller_unit.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/DIALOGUE_UTILS/custom_dialogue.dart';

void showPresetDeletionDialogue(String id, BuildContext context) {
  CustomBlurDialog.show(
    context: context,
    title: 'Confirm Deletion',
    content: 'Are you sure you delete this?',
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          'Cancel',
          style: TextStyle(color: Colors.deepPurple, fontSize: 18),
        ),
      ),
      TextButton(
        onPressed: () async {
          DataController.deleteDocument(id);
          Navigator.pop(context);
        },
        child: const Text(
          'Delete',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      ),
    ],
  );
}
