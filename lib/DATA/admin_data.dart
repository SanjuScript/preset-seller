
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/API/auth_api.dart';

class AdminData {
  static Future<int?> getTotalPresetsCount() async {
    try {
      QuerySnapshot snapshot = await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .get();
      log(snapshot.size.toString());

      return snapshot.size;
    } catch (e) {
      return null;
    }
  }

  static Future<void> storeNotificationToken(String token) async {
    try {
      User? currentUser = AuthApi.auth.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('admins').doc(userId);

        // Set the 'nfToken' field
        await userDocRef.set({'nfToken': token}, SetOptions(merge: true));
      } else {
        log("User is not authenticated.");
      }
    } catch (e) {
      log('Error storing notification token: $e');
      Fluttertoast.showToast(msg: "Failed to store notification token.");
    }
  }

  static Future<bool> isInstagramLinkSameAsCurrent(String newLink) async {
    try {
      final currentUser = AuthApi.auth.currentUser;
      final userDoc = AuthApi.admins.doc(currentUser!.uid);
      final userData = await userDoc.get();
      final currentInstagramLink = userData['instagram'];
      if (currentInstagramLink != null && currentInstagramLink == newLink) {
        print('Current Instagram link: $currentInstagramLink');
        print('New Instagram link: $newLink');
        return false;
      } else {
        return true;
      }
    } catch (e) {
      // Handle errors if needed
      return false;
    }
  }

  static Future<bool> isDescriptionSameAsCurrent(String newLink) async {
    try {
      final currentUser = AuthApi.auth.currentUser;
      final userDoc = AuthApi.admins.doc(currentUser!.uid);
      final userData = await userDoc.get();
      final currentInstagramLink = userData['description'];
      if (currentInstagramLink == newLink) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      // Handle errors if needed
      return false;
    }
  }

  static Future<String?> getPreviousPictureUrl() async {
    DocumentSnapshot snapshot =
        await AuthApi.admins.doc(AuthApi.auth.currentUser!.uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return data['profile_picture'];
  }

  static Future<DateTime?> getUserCreationDate() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      UserMetadata metadata = user.metadata;
      DateTime creationDate = metadata.creationTime!;
      return creationDate;
    }
    return null;
  }
}
