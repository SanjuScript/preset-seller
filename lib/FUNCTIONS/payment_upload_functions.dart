import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/FUNCTIONS/admin_data_controller_unit.dart';
import 'package:seller_app/MODEL/payment_data_model.dart';

class PaymentDataController {
  static Future<void> uploadPaymentDetails({
    required String upiNumberOrId,
  }) async {
    try {
      await AuthApi.admins
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('payment_info')
          .doc()
          .set({
        'upi_number_or_id': upiNumberOrId,
        'timestamp': Timestamp.now(),
      });

      Fluttertoast.showToast(
        msg: 'Payment details uploaded successfully.',
      );
      DataController.updatePaymentStatus(true);
    } catch (e) {
      log('Error uploading payment details: $e');
      Fluttertoast.showToast(
        msg: 'Failed to upload payment details. Please try again later.',
      );
    }
  }

  static Future<PaymentDetailModel?> retrievePaymentDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('admins')
          .doc(AuthApi.auth.currentUser!.uid)
          .collection('payment_info')
          .doc()
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return PaymentDetailModel.fromMap(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving payment details: $e');
      return null;
    }
  }
}
