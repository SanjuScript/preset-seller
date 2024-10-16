import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/delete_preset_pack.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/delete_single_preset.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/deletion_dialogue.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/log_out.dart';

class DialogueUtils {
  static void showDialogue(BuildContext context, String text,
      {dynamic arguments}) {
    switch (text.toLowerCase()) {
      case 'logout':
        showLogoutDialogue(context: context);
        break;
      case 'pdelete':
        showPresetDeletionDialogue(arguments[0], context);
        break;
      case 'cdelete':
        showCoverImageDeletionDialogue(
            arguments[0], arguments[1], arguments[2], context);
      case 'ppdelete':
        showPresetPackDeletionDialogue(arguments[0], context);

      default:
        break;
    }
  }
}
