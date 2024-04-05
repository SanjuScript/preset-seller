// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/AUTHENTICATION/authentication_page.dart';
import 'package:seller_app/AUTHENTICATION/login_page.dart';

class AuthController {
  static bool isUploading = false;

  static Future<void> resetpPassword(String email) async {
    try {
      await AuthApi.auth.sendPasswordResetEmail(email: email);
      FocusNode().unfocus();
      Fluttertoast.showToast(
          msg: 'Password reset link sent to $email. Please check your email.');
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Failed to send password reset link. Please try again later.');
    }
  }

  static Future<void> resendVerificationEmail(String email) async {
    try {
      User? user = AuthApi.auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        Fluttertoast.showToast(
          msg: 'Verification email sent to $email. Please check your inbox.',
        );
      } else {
        Fluttertoast.showToast(
          msg: 'User not found. Please login again.',
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to send verification email. Please try again later.',
      );
    }
  }

  static Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthenticationPage()),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Error signing out $e");
    }
  }

  static Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('admins') // Assuming 'admins' is your collection
              .doc(uid)
              .get();

      if (snapshot.exists) {
        // log(snapshot.data().forEach((key, value) {key.startsWith('pattern')}).toString());
        // log(snapshot.data());
        return snapshot.data();
      } else {
        print('User with UID $uid does not exist');
        return null;
      }
    } catch (e) {
      print('Error retrieving user details: $e');
      return null;
    }
  }

  static Future<void> updateDescription({
    required String description,
  }) async {
    try {
      await AuthApi.admins.doc(AuthApi.auth.currentUser!.uid).update({
        'description': description,
      });
      Fluttertoast.showToast(msg: 'User info updated successfully');
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Failed to update user info. Please try again later.');
    }
  }

  static Future<void> updateUserName({
    required String firstName,
    required String lastName,
  }) async {
    try {
      await AuthApi.admins.doc(AuthApi.auth.currentUser!.uid).update({
        'firstname': firstName,
        'lastname': lastName,
      });
      Fluttertoast.showToast(msg: 'Name updated successfully');
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Failed to update name. Please try again later.');
    }
  }

  static Future<void> uploadProfilePicture() async {
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
            .child('profile_pictures/${AuthApi.auth.currentUser!.uid}')
            .putFile(imageFile);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        log(downloadUrl);
        await AuthApi.admins
            .doc(AuthApi.auth.currentUser!.uid)
            .update({'profile_picture': downloadUrl});
        Fluttertoast.cancel();
        Fluttertoast.showToast(msg: 'Profile picture updated successfully');
      } catch (e) {
        log('Error uploading profile picture: $e');
        Fluttertoast.showToast(
            msg: 'Failed to upload profile picture. Please try again.');
      } finally {
        isUploading = false;
      }
    }
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

  static Future<void> deleteInstagramLink() async {
    try {
      await AuthApi.admins.doc(AuthApi.auth.currentUser!.uid).update({
        'instagram': FieldValue.delete(),
      });
      Fluttertoast.showToast(msg: 'Instagram link removed successfully');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to remove Instagram link. Please try again later.',
      );
    }
  }

  static Future<void> deleteDescription() async {
    try {
      await AuthApi.admins.doc(AuthApi.auth.currentUser!.uid).update({
        'description': FieldValue.delete(),
      });
      Fluttertoast.showToast(msg: 'Description removed successfully');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to remove description. Please try again later.',
      );
    }
  }

  static Future<void> deleteAdminAccount(BuildContext context) async {
    String? currentAdminId = FirebaseAuth.instance.currentUser?.uid;
    try {
      await AuthApi.admins.doc(currentAdminId).delete();
      await FirebaseAuth.instance.currentUser!.delete();
      print('Current admin account deleted successfully');
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AuthenticationPage()));
      });
    } on FirebaseAuthException catch (e) {
      log(e.toString());

      if (e.code == "requires-recent-login") {
        await reauthenticateAndDelete();
      } else {
        // Handle other Firebase exceptions
      }
    } catch (e) {
      log(e.toString());

      // Handle general exception
    }
  }

  static Future<void> reauthenticateAndDelete() async {
    try {
      final providerData = AuthApi.auth.currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await AuthApi.auth.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await AuthApi.auth.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await AuthApi.auth.currentUser?.delete();
    } catch (e) {
      // Handle exceptions
      log(e.toString());
    }
  }

  static Future<void> addInstagramLink({
    required String instagramLink,
  }) async {
    RegExp instagramRegex =
        RegExp(r'^https?://(?:www\.)?instagram\.com/[\w\.]+.*$');

    if (!instagramRegex.hasMatch(instagramLink)) {
      Fluttertoast.showToast(
        msg: 'Invalid Instagram link. Please enter a valid URL.',
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      await AuthApi.admins.doc(AuthApi.auth.currentUser!.uid).update({
        'instagram': instagramLink,
      });
      Fluttertoast.showToast(msg: 'Instagram link added successfully');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to add Instagram link. Please try again later.',
      );
    }
  }
}
