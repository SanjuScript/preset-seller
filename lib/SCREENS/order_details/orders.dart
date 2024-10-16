import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seller_app/CONSTANTS/fonts.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/EXTENSION/color_extension.dart';
import 'package:seller_app/SCREENS/order_details/purchase_history.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: HelperText1(
            text: "Orders".capitalizeFirstLetterOfEachWord(),
            color: Colors.black87,
            fontSize: 25,
          ),
          backgroundColor: Colors.white,
          bottom: const TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.black,
            labelStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            indicatorColor: Colors.black87,
            tabs: [
              Tab(text: 'Purchase History'),
              Tab(text: 'Withdrawal History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PurchaseHistory(),
            Container(
              child: const Center(
                child: Text('Withdrawal History Content'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
