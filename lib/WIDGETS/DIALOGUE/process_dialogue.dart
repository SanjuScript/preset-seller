import 'package:flutter/material.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';

class ProgressDialog extends StatelessWidget {
  final String text;

  const ProgressDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            HelperText1(
              text: text,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}

void showProcessDialogue(
    {required BuildContext context, required String text}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ProgressDialog(text: text);
    },
  );
}
