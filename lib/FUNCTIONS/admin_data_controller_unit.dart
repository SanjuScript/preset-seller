import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/MODEL/preset_data_model.dart';

class DataController {
  static bool isUploading = false;

  static Future<void> editPreset({
    required String docId,
    String? name,
    int? price,
    String? description,
  }) async {
    try {
      // Get the reference to the document
      DocumentReference presetRef = AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .doc(docId);

      // Check if the document exists before attempting to edit it
      DocumentSnapshot snapshot = await presetRef.get();
      if (!snapshot.exists) {
        throw Exception('Document with docId $docId does not exist');
      }

      // Create a map to hold the updated fields
      Map<String, dynamic> updatedFields = {};
      if (name != null) updatedFields['name'] = name;
      if (price != null) updatedFields['price'] = price;
      if (description != null) updatedFields['description'] = description;

      // Update the document with the provided fields
      await presetRef.update(updatedFields);

      Fluttertoast.showToast(
        msg: 'Preset edited successfully',
      );
    } catch (e) {
      print('Error editing preset: $e');
      Fluttertoast.showToast(
        msg: 'Failed to edit preset. Please try again.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  static Future<void> downloadDNGFile(
      String downloadUrl, String presetName) async {
    try {
      log(presetName);
      String filenameWithAppName =
          'seller_app_$presetName'; // Specify the file extension as .dng
      // Download the file to the temporary directory
      // File file = File('$tempPath/$filenameWithAppName');
      // await ref.writeToFile(file);

      // Directory appDocDir = await getApplicationDocumentsDirectory();
      // String appDocPath = '${appDocDir.path}/seller_app';
      // await Directory(appDocPath).create(recursive: true);
      // await file.copy('$appDocPath/$filenameWithAppName');
      FileDownloader.downloadFile(
        url: downloadUrl,
        name: filenameWithAppName,
        onDownloadError: (errorMessage) {
          log(errorMessage);
        },
        onProgress: (fileName, progress) {
          log(progress.toString());
        },
        onDownloadCompleted: (path) {
          log("Completed $path");
        },
      );

      // print('DNG file downloaded to: $appDocPath/$filenameWithAppName');
    } catch (e) {
      print('Error downloading DNG file: $e');
    }
  }

  static Future<void> deleteDocument(String docId) async {
    try {
      // Get the reference to the document containing the presets
      DocumentReference documentRef =
          AuthApi.documentRef.collection('lightroom_presets').doc(docId);

      // Delete the document
      await documentRef.delete();

      Fluttertoast.showToast(msg: 'Preset Pack deleted successfully');
    } catch (e) {
      debugPrint('Error deleting document: $e');
      Fluttertoast.showToast(
        msg: 'Failed to delete Preset. Please try again.',
        backgroundColor: Colors.red,
      );
    }
  }

  static Future<void> updatePaymentStatus(bool isPaymentSet) async {
    try {
      await FirebaseFirestore.instance.collection('admins').doc(AuthApi.auth.currentUser!.uid).update({
        'isPaymentSet': isPaymentSet,
      });
    } catch (e) {
      log('Error updating payment status: $e');
      
    }
  }

  static Future<void> deleteCoverImageByUrl({
    required String docId,
    required String coverImageUrl,
  }) async {
    try {
      log('Deleting coverImage. Document ID: $docId, coverImage URL: $coverImageUrl');

      DocumentReference documentRef =
          AuthApi.documentRef.collection('lightroom_presets').doc(docId);

      // Fetch the current coverImages array
      DocumentSnapshot snapshot = await documentRef.get();
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('coverImages')) {
        List<dynamic>? coverImagesData = data['coverImages'] as List<dynamic>?;

        if (coverImagesData != null) {
          List<String> coverImages = List<String>.from(coverImagesData);

          // Ensure that the array has at least one cover image
          if (coverImages.length > 1) {
            // Remove the specified cover image URL from the coverImages array
            await documentRef.update({
              'coverImages': FieldValue.arrayRemove([coverImageUrl]),
            });

            log('CoverImage deleted successfully');
            Fluttertoast.showToast(msg: 'CoverImage deleted successfully');
          } else {
            log('At least one cover image must remain');
            Fluttertoast.showToast(msg: 'At least one cover image must remain');
          }
        }
      }
    } catch (e) {
      log('Error deleting CoverImage: $e');
      debugPrint('Error deleting CoverImage: $e');
      Fluttertoast.showToast(
        msg: 'Failed to delete CoverImage. Please try again.',
      );
    }
  }

  static Future<PresetModel?> getPresetModelForDocId(String docId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('admins')
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('lightroom_presets')
          .doc(docId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return PresetModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching PresetModel for docId: $e');
      return null;
    }
  }
}
