import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime/mime.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:path/path.dart' as p;
import 'package:seller_app/API/notification_handling_api.dart';
import 'package:seller_app/CONTROLLER/network_controller.dart';

class DataUploadAdmin {
  static bool isUploading = false;

  // static StatusState status = StatusState.pending;
  static Future<void> uploadPreset({
    required String name,
    required int price,
    required String description,
    required List<File> presetData,
    required List<File> coverImages,
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

      int totalFiles = presetData.length + coverImages.length;
      int uploadedFiles = 0;

      if (!await NetworkInterceptor().isNetworkAvailable()) {
        Fluttertoast.showToast(
          msg:
              'No internet connection. Please connect to the internet and try again.',
          backgroundColor: Colors.red,
        );
        return;
      }

      NotificationApi.showProgressNotification(
        id: 0,
        title: 'Uploading Presets',
        body: 'Uploading in progress...',
      );
      List<String> presetImagesUrls = [];
      for (File file in presetData) {
        uploadedFiles++;
        double progress = uploadedFiles / totalFiles * 100;
        NotificationApi.updateProgressNotification(
          id: 0,
          progress: progress,
        );
        final extension = p.extension(file.path);
        log("Extension:$extension");
        String? mimeType = lookupMimeType(file.path);
        var metadata = SettableMetadata(
          contentType: mimeType,
        );
        var uploadTask = AuthApi.storage
            .ref()
            .child('lr_presets/${AuthApi.auth.currentUser!.uid}/'
                '${DateTime.now().millisecondsSinceEpoch}$extension')
            .putFile(file, metadata);
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          double progress =
              (100 * snapshot.bytesTransferred) / snapshot.totalBytes;
          log('Upload progress: $progress');
        });
        var snapshot = await uploadTask;
        var presetDownloadUrl = await snapshot.ref.getDownloadURL();
        presetImagesUrls.add(presetDownloadUrl);
      }

      // log(presetDownloadUrl);
      String ownerData = AuthApi.auth.currentUser!.uid;

      List<String> coverImagesUrls = [];
      for (int i = 0; i < coverImages.length; i++) {
        uploadedFiles++;
        double progress = uploadedFiles / totalFiles * 100;
        NotificationApi.updateProgressNotification(
          id: 0,
          progress: progress,
        );
        var coverImageuploadTask = AuthApi.storage
            .ref()
            .child('lr_presets/${AuthApi.auth.currentUser!.uid}/'
                '${DateTime.now().millisecondsSinceEpoch}.jpg')
            .putFile(coverImages[i]);

        coverImageuploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          double progress =
              (100 * snapshot.bytesTransferred) / snapshot.totalBytes;
          log('Upload progress: $progress');
        });
        var coverImageSnapshot = await coverImageuploadTask;
        var coverImageUrl = await coverImageSnapshot.ref.getDownloadURL();
        coverImagesUrls.add(coverImageUrl);
      }
      NotificationApi.removeNotification(id: 0);
      DocumentReference docRef = await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .add(
        {
          'presets': presetImagesUrls,
          'isList': false,
          'coverImages': coverImagesUrls,
          'name': name,
          'price': price,
          'presetsBoughtCount': 0,
          'likeCount': 0,
          "owner_data": ownerData,
          "shares": 0,
          "description": description,
          "status": "pending",
          "docId": '',
        },
      ); // Add the download URL to a document in the subcollection

      String docId = docRef.id;
      await docRef.update({"docId": docId});
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Presets uploaded successfully. They require manual approval.',
      );
      await NotificationApi.showSimpleNotification(
        title: "Presets Uploaded",
        body: "Your presets have been uploaded and are pending review.",
        payload: "preset_uploaded",
      );
    } catch (e) {
      log('Error uploading Lightroom Preset: $e');
      await NotificationApi.showSimpleNotification(
        title: "Upload Failure",
        body: "Failed to upload presets. Please try again later.",
        payload: "preset_upload_failure",
      );
      Fluttertoast.showToast(
          msg: 'Failed to upload Lightroom Preset. Please try again.');
    } finally {
      isUploading = false;
    }
  }

  static Future<void> uploadPresetList({
    required String name,
    required int price,
    required String description,
    required List<File> presetFiles,
    required List<File> coverImages,
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
      List<String> presetDownloadUrls = [];
      for (var pfile in presetFiles) {
        final extension = p.extension(pfile.path);
        log("Extension:$extension");
        String? mimeType = lookupMimeType(pfile.path);
        var metadata = SettableMetadata(
          contentType: mimeType,
        );

        var snapshot = await AuthApi.storage
            .ref()
            .child('lr_presets/${AuthApi.auth.currentUser!.uid}/'
                '${DateTime.now().millisecondsSinceEpoch}$extension')
            .putFile(pfile, metadata);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        presetDownloadUrls.add(downloadUrl);
      }
      List<String> coverImagesUrls = [];
      for (var coverImage in coverImages) {
        var coverImageSnapshot = await AuthApi.storage
            .ref()
            .child('lr_presets/${AuthApi.auth.currentUser!.uid}/'
                '${DateTime.now().millisecondsSinceEpoch}.jpg')
            .putFile(coverImage);
        var coverImageUrl = await coverImageSnapshot.ref.getDownloadURL();
        coverImagesUrls.add(coverImageUrl);
      }

      String ownerData = AuthApi.auth.currentUser!.uid;

      // Update the Firestore document in the "admins" collection
      DocumentReference docRef = await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection(
              'lightroom_presets') // Create a subcollection named "presets"
          .add(
        {
          'presets': presetDownloadUrls,
          'coverImages': coverImagesUrls,
          'isList': true,
          'name': name,
          'price': price,
          'presetsBoughtCount': 0,
          'likeCount': 0,
          "shares": 0,
          "owner_data": ownerData,
          "description": description,
          "status": "pending",
          "docId": '',
        },
      ); // Add the download URLs as an array to a document in the subcollection
      String docId = docRef.id;
      await docRef.update({"docId": docId});
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Presets uploaded successfully');
      await NotificationApi.showSimpleNotification(
        title: "Presets Uploaded",
        body: "Your presets have been uploaded and are pending review.",
        payload: "preset_uploaded",
      );
    } catch (e) {
      debugPrint('Error uploading Presets: $e');
      await NotificationApi.showSimpleNotification(
        title: "Upload Failure",
        body: "Failed to upload presets. Please try again later.",
        payload: "preset_upload_failure",
      );
      Fluttertoast.showToast(
        msg: 'Failed to upload Presets. Please try again.',
        backgroundColor: Colors.red,
      );
    } finally {
      isUploading = false;
    }
  }

  static Future<void> uploadProfilePicture(File imageFile) async {
    if (isUploading) {
      Fluttertoast.showToast(
        msg: 'A file is already being uploaded. Please wait.',
        backgroundColor: Colors.orange,
      );
      return;
    }
    Fluttertoast.showToast(
      msg: 'Uploading your profile picture....',
      backgroundColor: Colors.orange,
    );

    // Check image size
    int fileSizeInBytes = imageFile.lengthSync();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    if (fileSizeInMB > 5) {
      Fluttertoast.showToast(
        msg: 'Image size must not exceed 5MB',
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      isUploading = true;

      // Upload new picture
      var snapshot = await AuthApi.storage
          .ref()
          .child('profile_pictures/${AuthApi.auth.currentUser!.uid}.jpg')
          .putFile(imageFile);
      var downloadUrl = await snapshot.ref.getDownloadURL();

      // Update profile picture URL in the database
      await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .update({'profile_picture': downloadUrl});

      Fluttertoast.showToast(msg: 'Profile picture updated successfully');
      await NotificationApi.showSimpleNotification(
        title: "Profile Picture Uploaded",
        body: "Your profile picture has been uploaded successfully.",
        payload: "profile_picture_uploaded",
      );
    } catch (e) {
      print('Error uploading profile picture: $e');
      await NotificationApi.showSimpleNotification(
        title: "Upload Failure",
        body: "Failed to upload profile picture. Please try again later.",
        payload: "profile_picture_uploaded",
      );
      Fluttertoast.showToast(
          msg: 'Failed to upload profile picture. Please try again.');
    } finally {
      isUploading = false;
    }
  }

  static Future<void> addMoreCoverImages({
    required String docId,
    required bool isListedPreset,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        compressionQuality: 35,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg'],
      );

      final xfilePicks = result!.xFiles;

      if (xfilePicks == null || xfilePicks.isEmpty) {
        Fluttertoast.showToast(msg: 'No images selected');
        return;
      }

      List<File> newCoverImages = [];
      for (var i = 0; i < xfilePicks.length; i++) {
        newCoverImages.add(File(xfilePicks[i].path));
      }

      DocumentReference documentRef =
          AuthApi.documentRef.collection('lightroom_presets').doc(docId);

      // Fetch the current coverImages array
      DocumentSnapshot snapshot = await documentRef.get();
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('coverImages')) {
        List<dynamic>? existingCoverImagesData =
            data['coverImages'] as List<dynamic>?;

        if (existingCoverImagesData != null) {
          // Calculate the number of additional cover images that can be added
          const int oneTime = 4;
          const int moreList = 12;

          int remainingSlots = isListedPreset
              ? moreList
              : oneTime - existingCoverImagesData.length;

          if (remainingSlots <= 0) {
            log('Maximum number of cover images already reached');
            Fluttertoast.showToast(
                msg: 'Maximum number of cover images already reached');
            return;
          }

          // Upload new cover images
          List<String> newCoverImagesUrls = [];
          for (int i = 0;
              i < newCoverImages.length && i < remainingSlots;
              i++) {
            var coverImageSnapshot = await AuthApi.storage
                .ref()
                .child('lr_presets/${AuthApi.auth.currentUser!.uid}/'
                    '${DateTime.now().millisecondsSinceEpoch}_$i.jpg')
                .putFile(newCoverImages[i]);
            var coverImageUrl = await coverImageSnapshot.ref.getDownloadURL();
            newCoverImagesUrls.add(coverImageUrl);
          }

          // Combine existing and new cover images
          List<String> allCoverImagesUrls = [
            ...existingCoverImagesData.map((url) => url.toString()),
            ...newCoverImagesUrls
          ];

          // Update the Firestore document with all cover images
          await documentRef
              .update({'coverImages': allCoverImagesUrls, 'status': "pending"});
          String presetName = data['name'];
          await NotificationApi.showSimpleNotification(
            title: "Upload Success",
            body:
                "Your newly added images are successfully uploaded to $presetName",
            payload:
                "preset_cover_uploaded_$docId", // Include docId in the payload
          );

          log('New cover images added successfully');
          Fluttertoast.showToast(msg: 'New cover images added successfully');
        }
      }
    } catch (e) {
      log('Error adding new cover images: $e');
      await NotificationApi.showSimpleNotification(
        title: "Upload Failure",
        body: "Failed to upload images. Please try again later.",
        payload: "preset_cover_uploaded_$docId",
      );

      Fluttertoast.showToast(
        msg: 'Failed to add new cover images. Please try again.',
      );
    }
  }

  static Future<void> incrementPresetsBoughtCount(String docId) async {
    try {
      // Get the reference to the document
      DocumentReference presetRef = AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .doc(docId);

      // Update the presetsBoughtCount field using FieldValue.increment()
      await presetRef.update({
        'presetsBoughtCount': FieldValue.increment(1),
      });

      log('Presets bought count incremented successfully');
    } catch (e) {
      log('Error incrementing presets bought count: $e');
    }
  }
}
