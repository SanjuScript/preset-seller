import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  final num? balance;
  final DateTime? lastUpdated;
  final bool? isWithrawing;
  WalletModel({
    this.balance,
    this.isWithrawing,
    this.lastUpdated,
  });

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      balance: map['balance'],
      lastUpdated: (map['last_updated'] as Timestamp?)?.toDate(),
      isWithrawing: map['iswithdrawing']
    );
  }
}
