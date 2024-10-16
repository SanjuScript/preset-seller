import 'package:flutter/material.dart';
import 'package:seller_app/FUNCTIONS/admin_data_controller_unit.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/DIALOGUE_UTILS/custom_dialogue.dart';

void showPresetPackDeletionDialogue(String docid, BuildContext context) {
  CustomBlurDialog.show(
    context: context,
    title: 'Confirm Deletion',
    content: 'Are you sure you want to delete this pack?',
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
          await DataController.deleteDocument(docid);
          Navigator.pop(context);
          (context as Element).markNeedsBuild();
           Navigator.pop(context);
           Navigator.pop(context);
        },
        child: Text(
          'Delete',
          style: TextStyle(color: Colors.red[500]!, fontSize: 18),
        ),
      ),
    ],
  );
}
