import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentDetailModel {
  final String? upiNumberOrId;
  final Timestamp? timestamp;

  PaymentDetailModel({
    this.upiNumberOrId,
    this.timestamp,
  });

  factory PaymentDetailModel.fromMap(Map<String, dynamic> map) {
    return PaymentDetailModel(
      upiNumberOrId: map['upi_number_or_id'],
      timestamp: map['timestamp'],
    );
  }
}
