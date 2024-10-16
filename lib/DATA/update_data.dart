import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/AUTHENTICATION/authentication_page.dart';
import 'package:seller_app/SECURITY/storage_manager.dart';


class UpdateAdminData {
  static bool isUploading = false;
  static Future<void> updateProfilePicture(String imageUrl) async {
    try {
      isUploading = true;

      // Download image from URL
      HttpClient httpClient = HttpClient();
      var request = await httpClient.getUrl(Uri.parse(imageUrl));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);

      // Upload new picture
      var snapshot = await AuthApi.storage
          .ref()
          .child('profile_pictures/${AuthApi.auth.currentUser!.uid}.jpg')
          .putData(bytes);
      var downloadUrl = await snapshot.ref.getDownloadURL();

      await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .set({'profile_picture': downloadUrl});
    } catch (e) {
      log('Error uploading profile picture: $e');
      Fluttertoast.showToast(
        msg: 'Failed to upload profile picture. Please try again.',
        backgroundColor: Colors.red,
      );
    } finally {
      isUploading = false;
    }
  }

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
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
        await PerfectStateManager.saveState('isAuthenticated', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthenticationPage()),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Error signing out $e");
    }
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
      log('Current admin account deleted successfully');
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

  static Future<void> updateDescription({
    required String description,
  }) async {
    try {
      await AuthApi.admins.doc(AuthApi.auth.currentUser!.uid).update({
        'description': description,
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Failed to update user info. Please try again later.');
    }
  }

   static Future<void> setPassAndMail({
    required String mail,
    required String pass,
  }) async {
    try {
      await AuthApi.admins.doc(AuthApi.auth.currentUser!.uid).set({
        'password': pass,
        'mail':mail,
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Failed to update user info. Please try again later.');
    }
  }

  static Future<void> updateFirstName(String firstName) async {
    try {
      final currentUser = AuthApi.auth.currentUser;
      final userDoc = AuthApi.admins.doc(currentUser!.uid);
      final userData = await userDoc.get();
      final currentFirstName = userData['firstname'];

      if (currentFirstName == firstName) {
        Fluttertoast.showToast(
            msg: 'New first name is same as current first name');
        return;
      }

      await userDoc.update({'firstname': firstName});
      Fluttertoast.showToast(msg: 'First name updated successfully');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to update first name. Please try again later.',
      );
    }
  }

  static Future<void> updateLastName(String lastName) async {
    try {
      final currentUser = AuthApi.auth.currentUser;
      final userDoc = AuthApi.admins.doc(currentUser!.uid);
      final userData = await userDoc.get();
      final currentLastName = userData['lastname'];

      if (currentLastName == lastName) {
        Fluttertoast.showToast(
            msg: 'New last name is same as current last name');
        return;
      }

      await userDoc.update({'lastname': lastName});
      Fluttertoast.showToast(msg: 'Last name updated successfully');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to update last name. Please try again later.',
      );
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
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to add Instagram link. Please try again later.',
      );
    }
  }

  static Future<void> deleteProfilePicture() async {
    try {
      // Get reference to the profile picture
      var reference = AuthApi.storage
          .ref()
          .child('profile_pictures/${AuthApi.auth.currentUser!.uid}.jpg');

      // Delete the profile picture
      await reference.delete();

      // Update profile picture URL in the database to null or any default value
      await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .update({'profile_picture': null});

      Fluttertoast.showToast(msg: 'Profile picture deleted successfully');
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        Fluttertoast.showToast(msg: 'Profile picture does not exist');
      } else {
        print('Error deleting profile picture: $e');
        Fluttertoast.showToast(
            msg: 'Failed to delete profile picture. Please try again.');
      }
    }
  }
}
