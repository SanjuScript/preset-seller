// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/API/auth_api.dart';

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
}
