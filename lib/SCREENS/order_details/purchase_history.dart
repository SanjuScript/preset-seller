import 'package:flutter/cupertino.dart';
import 'package:seller_app/WIDGETS/CARD/purchase_card.dart';

class PurchaseHistory extends StatelessWidget {
  const PurchaseHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return PurchaseCard();
      },
    );
  }
}
