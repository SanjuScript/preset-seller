import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/DATA/admin_data.dart';
import 'package:seller_app/MODEL/admin_data_model.dart';

class UserProfileProvider extends ChangeNotifier {
  Stream<AdminProfile>? _userProfileStream;
  int? _uploadedCount;

  // Method to get the user profile stream
  Stream<AdminProfile>? getUserProfileStream() {
    if (AuthApi.auth.currentUser != null) {
      _userProfileStream = FirebaseFirestore.instance
          .collection('admins')
          .doc(AuthApi.auth.currentUser!.uid)
          .snapshots()
          .map((snapshot) => AdminProfile.fromMap(snapshot.data() ?? {}));
      return _userProfileStream;
    }
    return null;
  }

  // Method to get the total presets count
  Future<void> getTotalPresetsCount() async {
    if (AuthApi.auth.currentUser != null) {
      int? count = await AdminData.getTotalPresetsCount();
      _uploadedCount = count;
      notifyListeners();
    }
  }

  int? get uploadedCount => _uploadedCount;
}

