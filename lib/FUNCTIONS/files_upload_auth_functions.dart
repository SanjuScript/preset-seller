import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_app/API/auth_api.dart';

class DataUploadAdmin {
  static bool isUploading = false;

  static Future<void> deletePreset(String presetUrl,int index) async {
    try {
      QuerySnapshot snapshot = await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets').get();
      String docId = snapshot.docs[index].id;
      log(docId);
      // Get the reference to the document containing the presets
      DocumentReference documentRef = AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .doc(docId); // Replace with the actual document ID

      // Remove the specified preset URL from the presets array
      // log(documentRef.parent.toString());
      await documentRef.update({
        'presets': FieldValue.arrayRemove([presetUrl]),
      });

      Fluttertoast.showToast(msg: 'Preset deleted successfully');
    } catch (e) {
      debugPrint('Error deleting preset: $e');
      Fluttertoast.showToast(
        msg: 'Failed to delete preset. Please try again.',
        backgroundColor: Colors.red,
      );
    }
  }
 static Future<void> deleteDocument(String docId) async {
  try {
    // Get the reference to the document containing the presets
    DocumentReference documentRef = FirebaseFirestore.instance
        .collection('admins')
        .doc(AuthApi.auth.currentUser!.uid)
        .collection('lightroom_presets')
        .doc(docId);

    // Delete the document
    await documentRef.delete();

    Fluttertoast.showToast(msg: 'Document deleted successfully');
  } catch (e) {
    debugPrint('Error deleting document: $e');
    Fluttertoast.showToast(
      msg: 'Failed to delete document. Please try again.',
      backgroundColor: Colors.red,
    );
  }
}



  static Future<void> deleteListOfPreset(List<String> presetUrl) async {
    try {
      QuerySnapshot snapshot = await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .get();
      String docId = snapshot.docs.first.id;
      log(docId);
      // Get the reference to the document containing the presets
      DocumentReference documentRef = AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .doc(docId); // Replace with the actual document ID

      // Remove the specified preset URL from the presets array
      log(documentRef.parent.toString());
      await documentRef.update({
        'presets': FieldValue.arrayRemove(presetUrl),
      });

      Fluttertoast.showToast(msg: 'Preset deleted successfully');
    } catch (e) {
      debugPrint('Error deleting preset: $e');
      Fluttertoast.showToast(
        msg: 'Failed to delete preset. Please try again.',
        backgroundColor: Colors.red,
      );
    }
  }

  static Future<void> uploadPreset(
      {required String name, required int price}) async {
    if (isUploading) {
      Fluttertoast.showToast(
        msg: 'A file is already being uploaded. Please wait.',
        backgroundColor: Colors.orange,
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
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
      Fluttertoast.showToast(
        msg: 'Uploading profile picture...',
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 60,
      );
      try {
        isUploading = true;
        var snapshot = await AuthApi.storage
            .ref()
            .child('lr_presets/${AuthApi.auth.currentUser!.uid}')
            .putFile(imageFile);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        log(downloadUrl);
        String ownerData = AuthApi.auth.currentUser!.uid;

        // Update the Firestore document in the "admins" collection

        await AuthApi.admins
            .doc(AuthApi.auth.currentUser!.uid)
            .collection(
                'lightroom_presets') // Create a subcollection named "lightroom_presets"
            .add(
          {
            'preset': downloadUrl,
            'name': name,
            'price': price,
            "owner_data": ownerData,
          },
        ); // Add the download URL to a document in the subcollection
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: 'Lightroom Preset uploaded successfully');
      } catch (e) {
        log('Error uploading Lightroom Preset: $e');
        Fluttertoast.showToast(
            msg: 'Failed to upload Lightroom Preset. Please try again.');
      } finally {
        isUploading = false;
      }
    }
  }

  static Future<void> addMoreImagesToPresetList(String docId) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles == null || pickedFiles.isEmpty) {
      Fluttertoast.showToast(
        msg: 'No presets selected for upload.',
        backgroundColor: Colors.orange,
      );
      return;
    }

    if (isUploading) {
      Fluttertoast.showToast(
        msg: 'A file is already being uploaded. Please wait.',
        backgroundColor: Colors.orange,
      );
      return;
    }

    Fluttertoast.showToast(
      msg: 'Uploading presets...',
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_LONG,
    );

    try {
      isUploading = true;
      List<String> downloadUrls = [];
      for (var pickedFile in pickedFiles) {
        final bytes = await pickedFile.readAsBytes();
        final Uint8List uint8List = Uint8List.fromList(bytes);
        final file = File(pickedFile.path)..writeAsBytesSync(uint8List);
        // Check preset file size
        int fileSizeInBytes = file.lengthSync();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        if (fileSizeInMB > 5) {
          Fluttertoast.showToast(
            msg: 'Preset size must not exceed 5MB',
            backgroundColor: Colors.red,
          );
          return;
        }

        var snapshot = await AuthApi.storage
            .ref()
            .child(
                'lr_presets/${AuthApi.auth.currentUser!.uid}/${file.path.split('/').last}')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      // String ownerData = AuthApi.auth.currentUser!.uid;

      // Fetch the document ID of the preset document
      QuerySnapshot snapshot = await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .get();
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

  static Future<void> uploadPresetList({
    required String name,
    required int price,
  }) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles == null || pickedFiles.isEmpty) {
      Fluttertoast.showToast(
        msg: 'No presets selected for upload.',
        backgroundColor: Colors.orange,
      );
      return;
    }

    if (isUploading) {
      Fluttertoast.showToast(
        msg: 'A file is already being uploaded. Please wait.',
        backgroundColor: Colors.orange,
      );
      return;
    }

    Fluttertoast.showToast(
        msg: 'Uploading presets...',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG);

    try {
      isUploading = true;
      List<String> downloadUrls = [];
      for (var pickedFile in pickedFiles) {
        final bytes = await pickedFile.readAsBytes();
        final Uint8List uint8List = Uint8List.fromList(bytes);
        final file = File(pickedFile.path)..writeAsBytesSync(uint8List);
        // Check preset file size
        int fileSizeInBytes = file.lengthSync();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        if (fileSizeInMB > 5) {
          Fluttertoast.showToast(
            msg: 'Preset size must not exceed 5MB',
            backgroundColor: Colors.red,
          );
          return;
        }

        var snapshot = await AuthApi.storage
            .ref()
            .child(
                'lr_presets/${AuthApi.auth.currentUser!.uid}/${file.path.split('/').last}')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      String ownerData = AuthApi.auth.currentUser!.uid;

      // Update the Firestore document in the "admins" collection
      await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection(
              'lightroom_presets') // Create a subcollection named "presets"
          .add(
        {
          'presets': downloadUrls,
          'name': name,
          'price': price,
          "owner_data": ownerData,
        },
      ); // Add the download URLs as an array to a document in the subcollection

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
}
