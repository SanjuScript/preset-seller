import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PurchaseCard extends StatelessWidget {
  const PurchaseCard({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(10),
      height: size.height * .28,
      width: size.width * .90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            offset: Offset(2, -2),
            blurRadius: 10,
            color: Colors.black12,
          ),
          BoxShadow(
            offset: Offset(-2, 2),
            blurRadius: 5,
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Purchase ID "),
              Text(
                "#1749736239569282",
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
