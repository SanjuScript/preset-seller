import 'package:flutter/material.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';

class GetText1 extends StatelessWidget {
  final String text;
  const GetText1({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Text(
      text.toString().capitalizeFirstLetterOfEachWord(),
      style: TextStyle(
        fontSize: size.width * 0.06,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'rounder',
      ),
    );
  }
}
