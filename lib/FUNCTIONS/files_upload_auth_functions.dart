import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime/mime.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/HELPERS/status_helper.dart';
import 'package:path/path.dart' as p;

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
      List<String> presetImagesUrls = [];
      for (File file in presetData) {
        final extension = p.extension(file.path);
        log("Extension:$extension");
        String? mimeType = lookupMimeType(file.path);
        var metadata = SettableMetadata(
          contentType: mimeType,
        );
        var snapshot = await AuthApi.storage
            .ref()
            .child('lr_presets/${AuthApi.auth.currentUser!.uid}/'
                '${DateTime.now().millisecondsSinceEpoch}$extension')
            .putFile(file, metadata);
        var presetDownloadUrl = await snapshot.ref.getDownloadURL();

        presetImagesUrls.add(presetDownloadUrl);
      }

      // log(presetDownloadUrl);
      String ownerData = AuthApi.auth.currentUser!.uid;

      List<String> coverImagesUrls = [];
      for (int i = 0; i < coverImages.length; i++) {
        var coverImageSnapshot = await AuthApi.storage
            .ref()
            .child('lr_presets/${AuthApi.auth.currentUser!.uid}/'
                '${DateTime.now().millisecondsSinceEpoch}.jpg')
            .putFile(coverImages[i]);
        var coverImageUrl = await coverImageSnapshot.ref.getDownloadURL();
        coverImagesUrls.add(coverImageUrl);
      }

      // Update the Firestore document in the "admins" collection
      String name = AuthApi.auth.currentUser!.displayName.toString();
      DocumentReference docRef = await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection(
              'lightroom_presets') // Create a subcollection named "lightroom_presets"
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
    } catch (e) {
      log('Error uploading Lightroom Preset: $e');
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
    } catch (e) {
      debugPrint('Error uploading Presets: $e');
      Fluttertoast.showToast(
        msg: 'Failed to upload Presets. Please try again.',
        backgroundColor: Colors.red,
      );
    } finally {
      isUploading = false;
    }
  }

  static Future<void> addMoreImagesToPresetList({
    required String docId,
    required List<File> presetFiles,
  }) async {
    try {
      isUploading = true;
      List<String> downloadUrls = [];
      for (var pickedFile in presetFiles) {
        var snapshot = await AuthApi.storage
            .ref()
            .child(
                'lr_presets/${AuthApi.auth.currentUser!.uid}/${pickedFile.path.split('/').last}')
            .putFile(pickedFile);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }

      // String docId = snapshot.docs.first.id;
      log(docId);
      // Update the Firestore document with the fetched document ID
      await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .doc(docId)
          .update({
        'presets': FieldValue.arrayUnion(downloadUrls),
      });
      for (var url in downloadUrls) {
        await AuthApi.admins
            .doc(AuthApi.auth.currentUser!.uid)
            .collection('lightroom_presets')
            .where('presets', arrayContains: url)
            .get()
            .then((snapshot) {
          for (var doc in snapshot.docs) {
            if (doc.exists) {
              doc.reference.update({'status': 'pending'});
            }
          }
        });
      }
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Additional images uploaded successfully');
    } catch (e) {
      debugPrint('Error uploading additional images: $e');
      Fluttertoast.showToast(
        msg: 'Failed to upload additional images. Please try again.',
        backgroundColor: Colors.red,
      );
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
          const int moreList = 10;

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

          log('New cover images added successfully');
          Fluttertoast.showToast(msg: 'New cover images added successfully');
        }
      }
    } catch (e) {
      log('Error adding new cover images: $e');
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

      print('Presets bought count incremented successfully');
    } catch (e) {
      print('Error incrementing presets bought count: $e');
    }
  }
}
