import 'package:flutter/material.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';

class HelperText2 extends StatelessWidget {
  final String text;
  final Color color;
  const HelperText2({super.key, required this.text,this.color =Colors.black });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Text(
        text.toString().capitalizeFirstLetterOfEachWord(),
        maxLines: 3,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: size.width * 0.04,
          overflow: TextOverflow.ellipsis,
          color: color
          // fontFamily: 'rounder',
        ),
      ),
    );
  }
}
