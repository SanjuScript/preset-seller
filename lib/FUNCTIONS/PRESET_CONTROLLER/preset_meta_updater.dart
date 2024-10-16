import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/API/notification_handling_api.dart';
import 'package:seller_app/CONTROLLER/network_controller.dart';

class UpdatePresetData {
  static bool isUploading = false;
  static Future<void> updateShowMRP({
    required String docId,
    required bool showMRP,
  }) async {
    try {
      DocumentReference docRef = AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .doc(docId);

      await docRef.update({
        'showMRP': showMRP,
      });

      Fluttertoast.showToast(
        msg: 'Show MRP updated successfully.',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      debugPrint('Error updating show MRP: $e');
      Fluttertoast.showToast(
        msg: 'Failed to update Show MRP. Please try again.',
        backgroundColor: Colors.red,
      );
    }
  }

 static Future<void> updateCoverImages({
    required String docId,
    required List<File> newCoverImages,
    required List<String> oldCoverImagesUrls,
  }) async {
    if (isUploading) {
      Fluttertoast.showToast(
        msg: 'A file is already being uploaded. Please wait.',
        backgroundColor: Colors.orange,
      );
      return;
    }

    try {
      isUploading = true;

      int totalFiles = newCoverImages.length;
      int uploadedFiles = 0;

      if (!await NetworkInterceptor.isNetworkAvailable()) {
        Fluttertoast.showToast(
          msg:
              'No internet connection. Please connect to the internet and try again.',
          backgroundColor: Colors.red,
        );
        return;
      }

      NotificationApi.showProgressNotification(
        id: 0,
        title: 'Adding new Cover Images',
        body: 'Uploading in progress...',
      );

      List<String> updatedCoverImagesUrls = List.from(oldCoverImagesUrls);

      for (File file in newCoverImages) {
        uploadedFiles++;
        double progress = uploadedFiles / totalFiles * 100;
        NotificationApi.updateProgressNotification(
          id: 0,
          progress: progress,
        );

        var uploadTask = AuthApi.storage
            .ref()
            .child(
                'lr_presets/${AuthApi.auth.currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg')
            .putFile(file);

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          double progress =
              (100 * snapshot.bytesTransferred) / snapshot.totalBytes;
          log('Upload progress: $progress');
        });

        var snapshot = await uploadTask;
        var coverImageUrl = await snapshot.ref.getDownloadURL();
        updatedCoverImagesUrls.add(coverImageUrl);
      }

      NotificationApi.removeNotification(id: 0);

      await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .doc(docId)
          .update({
        'coverImages': updatedCoverImagesUrls,
        "status": "pending",
      });

      Fluttertoast.showToast(
        msg: 'Cover images uploaded successfully.',
      );

      await NotificationApi.showSimpleNotification(
        title: "Cover Images Updated",
        body: "Your cover images have been updated.",
        payload: "cover_images_updated",
      );
    } catch (e) {
      log('Error uploading cover images: $e');
      await NotificationApi.showSimpleNotification(
        title: "Upload Failure",
        body: "Failed to upload cover images. Please try again later.",
        payload: "cover_image_upload_failure",
      );
      Fluttertoast.showToast(
        msg: 'Failed to upload cover images. Please try again.',
      );
    } finally {
      isUploading = false;
    }
  }

  static Future<void> updateSellingType({
    required String docId,
    required bool isPaid,
  }) async {
    try {
      DocumentReference docRef = AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .doc(docId);

      await docRef.update({
        'isPaid': isPaid,
      });

      log('status updated');
    } catch (e) {
      debugPrint('Error updating status: $e');
      Fluttertoast.showToast(
        msg: 'Failed to update status. Please try again.',
        backgroundColor: Colors.red,
      );
    }
  }

  static Future<void> updateHideOffer({
    required String docId,
    required bool hideOffer,
  }) async {
    try {
      log(docId);
      DocumentReference docRef = AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .doc(docId);

      await docRef.update({
        'hideOffer': hideOffer,
      });

      Fluttertoast.showToast(
        msg: 'Hide Offer updated successfully.',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      debugPrint('Error updating hide offer: $e');
      log(e.toString());
      Fluttertoast.showToast(
        msg: 'Failed to update Hide Offer. Please try again.',
        backgroundColor: Colors.red,
      );
    }
  }

  static Future<void> updateMainPresetData({
    required Map<String, dynamic> updateData,
    required String docId,
  }) async {
    try {
      log(docId);
      DocumentReference docRef = AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .doc(docId);

      await docRef.update(updateData);
//  "description": desc,
//         "name": name,
//         'price': price,
//         'mrp': mrp,
      Fluttertoast.showToast(
        msg: 'Preset details updated successfully.',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      debugPrint('Error updating preset details: $e');
      log(e.toString());
      Fluttertoast.showToast(
        msg: 'Failed to update preset details. Please try again.',
        backgroundColor: Colors.red,
      );
    }
  }
}
