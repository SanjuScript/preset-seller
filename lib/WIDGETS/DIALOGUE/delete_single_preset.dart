import 'package:flutter/material.dart';
import 'package:seller_app/FUNCTIONS/admin_data_controller_unit.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/DIALOGUE_UTILS/custom_dialogue.dart';

void showCoverImageDeletionDialogue(
    String docid, List<String> url, int index, BuildContext context) {
  CustomBlurDialog.show(
    context: context,
    title: 'Confirm Deletion',
    content: 'Are you sure you want to delete this?',
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
          // Delete from the database
          await DataController.deleteCoverImageByUrl(
              coverImageUrl: url[index], docId: docid);

          url.removeAt(index);

          Navigator.pop(context);
          (context as Element).markNeedsBuild();
        },
        child: const Text(
          'Delete',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      ),
    ],
  );
}
