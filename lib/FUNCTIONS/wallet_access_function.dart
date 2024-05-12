import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/MODEL/wallet_data_model.dart';

class WalletController {
  static Future<void> createWalletCollection(String uid) async {
    try {
      await AuthApi.admins
          .doc(uid)
          .collection('wallet')
          .doc('wallet_data')
          .set({
        "balance": 0,
        "last_updated": DateTime.now(),
        "iswithdrawing": false,
      });
      log("Wallet collection created successfully for user with UID: $uid");
    } catch (e) {
      log("Error creating wallet collection: $e");
      throw Exception("Failed to create wallet collection");
    }
  }

  static Stream<WalletModel?> getWalletDataStream() {
    try {
      return AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('wallet')
          .doc('wallet_data')
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data()!;
          return WalletModel.fromMap(data);
        } else {
          log('Wallet data not found for user with UID: ${AuthApi.auth.currentUser!.displayName}');
          return null;
        }
      });
    } catch (e) {
      log("Error retrieving wallet data: $e");
      return const Stream.empty();
    }
  }

  static Future<void> updateIsWithdrawing(
      {required bool isWithdrawing, required num amount}) async {
    try {
      await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('wallet')
          .doc('wallet_data')
          .update({
        'iswithdrawing': isWithdrawing,
        "balance": amount,
        "last_updated":DateTime.now(),
      });
      log("isWithdrawing updated successfully to $isWithdrawing");
    } catch (e) {
      log("Error updating isWithdrawing: $e");
      throw Exception("Failed to update isWithdrawing");
    }
  }
}
