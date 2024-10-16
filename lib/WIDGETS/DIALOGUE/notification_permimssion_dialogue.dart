import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seller_app/API/notification_handling_api.dart';

class NotificationPermissionDialog extends StatelessWidget {
  const NotificationPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Notification Permission"),
      content: const Text(
          "Please allow notification permissions to receive important updates."),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            await openAppSettings();
            Navigator.of(context).pop();
          },
          child: const Text("Settings"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
