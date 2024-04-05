import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/AUTHENTICATION/authentication_page.dart';
import 'package:seller_app/SCREENS/bottom_nav.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/verification_dialogue.dart';

class LoginAuth {
  static Future<void> doSignIn({
    required BuildContext context,
    required String email,
    required String pass,
  }) async {
    try {
      UserCredential userCredential =
          await AuthApi.auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      User? user = userCredential.user;

      if (user != null) {
        if (user.emailVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),
          );
          Fluttertoast.showToast(
            msg: 'Please verify your email ',
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Login failed. Please check your email and password',
        );
      }
    } catch (e) {
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
      UserCredential userCredential = await AuthApi.auth
          .createUserWithEmailAndPassword(email: email, password: pass);
      String uid = userCredential.user!.uid;
      await AuthApi.admins.doc(uid).set(
        {
          "uid": uid,
          "email": email,
          "firstname": firstName,
          "lastname": lastName,
        },
      );
      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName('$firstName $lastName');
        await user.sendEmailVerification();

        FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
          VerificationDialogue.showAccountCreatedDialog(context);

          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AuthenticationPage()),
            );
          });
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
      print('Error creating account: $e');
      Fluttertoast.showToast(
          msg: 'Failed to create account. Please try again later.');
    }
  }
}
