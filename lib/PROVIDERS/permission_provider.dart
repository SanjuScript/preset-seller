import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionProvider extends ChangeNotifier {
  bool isStoragePermission = false;
  bool isPhotosPermission = false;

  bool get _isStoragePermission => isStoragePermission;
  bool get _isPhotosPermission => isPhotosPermission;

  Future<void> checkPermissions() async {
    var storageStatus = await Permission.storage.status;
    var photosStatus = await Permission.photos.status;

    isStoragePermission = storageStatus.isGranted;
    isPhotosPermission = photosStatus.isGranted;

    notifyListeners();
  }
}
