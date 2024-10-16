// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/API/notification_handling_api.dart';
import 'package:seller_app/AUTHENTICATION/authentication_page.dart';
import 'package:seller_app/CONTROLLER/network_controller.dart';
import 'package:seller_app/DATA/update_data.dart';
import 'package:seller_app/FUNCTIONS/wallet_access_function.dart';
import 'package:seller_app/HELPERS/key_encrypter.dart';
import 'package:seller_app/MODEL/wallet_data_model.dart';
import 'package:seller_app/ROUTER/page_router.dart';
import 'package:seller_app/SCREENS/bottom_nav.dart';
import 'package:seller_app/SECURITY/storage_manager.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/disabled_dialogue.dart';

class LoginAuthProvider extends ChangeNotifier {
  static final NetworkInterceptor networkInterceptor = NetworkInterceptor();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _admins =
      FirebaseFirestore.instance.collection('admins');
  bool _gsign = false;
  bool get gsign => _gsign;
  bool _signUp = false;
  bool get signUP => _signUp;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> doSignIn(
    BuildContext context,
    String email,
    String pass,
  ) async {
    try {
      UserCredential userCredential =
          await AuthApi.auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      String getPass = KeyEncrypter.encrypt(pass);
      UpdateAdminData.setPassAndMail(mail: email, pass: getPass);
      User? user = userCredential.user;

      if (user != null) {
        await PerfectStateManager.saveState('isAuthenticated', true);

        // Check if the user is already on the homepage
        // if (Navigator.canPop(context)) {
        //   Navigator.pushReplacement(

        // }
        // navigationKey.currentState!
        //     .pushReplacement(MaterialPageRoute(builder: (context) {
        //   return BottomNav();
        // }));
        // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => BottomNav()),
        //     (route) => false);

        // AppRouter.of(context).go('/');
        AppRouter.router.refresh();
        AppRouter.router.go('/');
        if (!user.emailVerified) {
          Fluttertoast.showToast(
            msg: 'Please verify your email',
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Login failed. Please check your email and password',
        );
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      String errorMessage =
          'Login failed. Please check your email and password';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else if (e.code == "user-disabled") {
        showDisabledDialogue(context);
      }
      Fluttertoast.showToast(msg: errorMessage);
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(
          msg: 'Login failed. Please check your email and password');
    } finally {
      _loginLoading(false);
    }
  }

  Future<void> doGoogleSignIn(BuildContext context) async {
    _gsignLoading(true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        _gsignLoading(false);
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      QuerySnapshot querySnapshot = await AuthApi.admins
          .where('email', isEqualTo: googleSignInAccount.email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await googleSignIn.disconnect();
        await googleSignIn.signOut();

        Fluttertoast.showToast(
          msg: 'User does not exist. Please sign up first.',
        );
        _gsignLoading(false);
        return; // Exit the function
      }

      // User exists, proceed with Firebase authentication
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        await PerfectStateManager.saveState('isAuthenticated', true);

        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNav()),
        );

        if (!user.emailVerified) {
          Fluttertoast.showToast(
            msg: 'Please verify your email ',
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network_error') {
        Fluttertoast.showToast(
          msg:
              'Network error occurred. Please check your internet connection and try again.',
        );
      } else if (e.code == "user-disabled") {
        log("The user account has been disabled by an administrator.");
        showDisabledDialogue(context);
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
    } finally {
      _gsignLoading(false);
    }
  }

  Future<void> doSignUp(BuildContext context, String email, String firstName,
      String lastName, String pass) async {
    // Ensure the password is at least 6 characters long
    if (pass.length < 6) {
      Fluttertoast.showToast(
          msg:
              'The password provided is too weak. Password should be at least 6 characters');
      return;
    }

    _signUPLoading(true);
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass);
      String uid = userCredential.user!.uid;
      await _admins.doc(uid).set({
        "uid": uid,
        "email": email,
        "firstname": firstName,
        "lastname": lastName,
      });
      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName('$firstName $lastName');
        await user.sendEmailVerification();
        WalletController.createWalletCollection(uid);
        if (!user.emailVerified) {
          Fluttertoast.showToast(
              msg: 'An email verification link has sent to your email');
        }

        Future.delayed(Durations.long3, () {
          Fluttertoast.showToast(msg: 'Please Login ');
        });
      } else {
        Fluttertoast.showToast(
            msg: 'Failed to create account. Please try again later.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg:
                'The password provided is too weak. Password should be at least 6 characters');
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
    } finally {
      _signUPLoading(false);
    }
  }

  void _loginLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _signUPLoading(bool value) {
    _signUp = value;
    notifyListeners();
  }

  void _gsignLoading(bool value) {
    _gsign = value;
    notifyListeners();
  }
}
