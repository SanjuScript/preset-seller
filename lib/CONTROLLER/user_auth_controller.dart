import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/AUTHENTICATION/authentication_page.dart';
import 'package:seller_app/ROUTER/page_router.dart';
import 'package:seller_app/SECURITY/storage_manager.dart';

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
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await PerfectStateManager.saveState('isAuthenticated', false);
      Future.delayed(const Duration(milliseconds: 100), () {
        AppRouter.router.go('/');
        log('navigated');
      });
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        ;
        return snapshot.data();
      } else {
        log('User with UID $uid does not exist');
        return null;
      }
    } catch (e) {
      log('Error retrieving user details: $e');
      return null;
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

  static Future<void> deleteUserAccount(BuildContext context) async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    try {
      await AuthApi.admins.doc(currentUserId).delete();
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
}
