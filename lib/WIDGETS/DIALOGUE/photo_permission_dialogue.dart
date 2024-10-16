import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoPermissionDialog extends StatelessWidget {
  const PhotoPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Gallery Access Permission"),
      content: const Text(
          "Please allow access to your gallery to upload and manage photos."),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            await openAppSettings();  // Opens the app settings if permission is denied
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
 Future<bool> checkPhotoGalleryPermission() async {
  bool photoPermissionGranted = false;
  if (!kIsWeb) {
    // Request permission for gallery/photos
    PermissionStatus status = await Permission.photos.request();
    photoPermissionGranted = status == PermissionStatus.granted;
  }
  return photoPermissionGranted;
}

Future<void> checkPhotoGalleryPermissionAndAsk(BuildContext context) async {
  bool isPhotoPermissionGranted = await checkPhotoGalleryPermission();
  if (!isPhotoPermissionGranted) {
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return const PhotoPermissionDialog();
      },
    );
  }
}