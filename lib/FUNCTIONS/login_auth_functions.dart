// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/API/notification_handling_api.dart';
import 'package:seller_app/AUTHENTICATION/authentication_page.dart';
import 'package:seller_app/CONTROLLER/network_controller.dart';
import 'package:seller_app/FUNCTIONS/wallet_access_function.dart';
import 'package:seller_app/SCREENS/bottom_nav.dart';

class LoginAuth {
  static Future<void> doSignIn({
    required BuildContext context,
    required String email,
    required String pass,
  }) async {
    try {
      if (!await NetworkInterceptor().isNetworkAvailable()) {
        Fluttertoast.showToast(
          msg:
              'No internet connection. Please connect to the internet and try again.',
          backgroundColor: Colors.red,
        );
        return;
      }

      UserCredential userCredential =
          await AuthApi.auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      User? user = userCredential.user;

      if (user != null) {
        Navigator.pushReplacement(
          navigatorKey.currentState!.context,
          MaterialPageRoute(builder: (context) => const BottomNav()),
        );

        if (!user.emailVerified) {
          Fluttertoast.showToast(
            msg: 'Please verify your email ',
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Login failed. Please check your email and password',
        );
      }

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage =
          'Login failed. Please check your email and password';

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }

      Fluttertoast.showToast(
        msg: errorMessage,
      );
    } catch (e) {
      log('Error signing in: $e');
      Fluttertoast.showToast(
        msg: 'Login failed. Please check your email and password',
      );
    }
  }

  static Future<void> doSignUP(
      {required BuildContext context,
      required String email,
      required String firstName,
      required String lastName,
      required String pass}) async {
    try {
      if (!await NetworkInterceptor().isNetworkAvailable()) {
        Fluttertoast.showToast(
          msg:
              'No internet connection. Please connect to the internet and try again.',
          backgroundColor: Colors.red,
        );
        return;
      }
      UserCredential userCredential = await AuthApi.auth
          .createUserWithEmailAndPassword(email: email, password: pass);
      String uid = userCredential.user!.uid;
      await AuthApi.admins.doc(uid).set(
        {
          "uid": uid,
          "email": email,
          "firstname": firstName,
          "lastname": lastName,
          "isPaymentSet": false,
          "likes": 0,
        },
      );
      await WalletController.createWalletCollection(uid);

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName('$firstName $lastName');
        await user.sendEmailVerification();

        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            navigatorKey.currentState!.context,
            MaterialPageRoute(builder: (context) => const AuthenticationPage()),
          );
        });
        Fluttertoast.showToast(msg: 'Account Created');
      } else {
        Fluttertoast.showToast(
            msg: 'Failed to create account. Please try again later.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.');
      } else {
        Fluttertoast.showToast(
            msg: 'Failed to create account. Please try again later.');
      }
    } catch (e) {
      log('Error creating account: $e');
      Fluttertoast.showToast(
          msg: 'Failed to create account. Please try again later.');
    }
  }

  //google sign in
  static Future<void> doGoogleSignIn(BuildContext context) async {
    try {
      if (!await NetworkInterceptor().isNetworkAvailable()) {
        Fluttertoast.showToast(
          msg:
              'No internet connection. Please connect to the internet and try again.',
          backgroundColor: Colors.red,
        );
        return;
      }

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot documentSnapshot =
            await AuthApi.admins.doc(user.uid).get();
        if (!documentSnapshot.exists) {
          await AuthApi.admins.doc(user.uid).set(
            {
              "uid": user.uid,
              "email": user.email,
              "firstname": user.displayName,
              "lastname": "seller",
              "profile_picture": user.photoURL,
              "isPaymentSet": false,
              "likes": 0,
            },
          );
          await WalletController.createWalletCollection(user.uid);

          await user.updateDisplayName('${user.displayName}');
        }
        log(user.emailVerified.toString());
        Navigator.pushReplacement(
          navigatorKey.currentState!.context,
          MaterialPageRoute(builder: (context) => const BottomNav()),
        );
        if (!user.emailVerified) {
          // user.sendEmailVerification();

          Fluttertoast.showToast(
            msg: 'Please verify your email ',
          );
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'network_error') {
        Fluttertoast.showToast(
          msg:
              'Network error occurred. Please check your internet connection and try again.',
        );
      } else {
        log('Error signing in with Google: $e');
        Fluttertoast.showToast(
          msg: 'Google Sign-In failed. Please try again later.',
        );
      }
    } catch (e) {
      log('Error signing in with Google: $e');
      Fluttertoast.showToast(
        msg: 'Google Sign-In failed. Please try again later.',
      );
    }
  }
}
