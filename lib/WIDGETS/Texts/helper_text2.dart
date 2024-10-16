import 'package:flutter/material.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';

class GetText1 extends StatelessWidget {
  final String text;
  final double size;
  const GetText1({super.key, required this.text,required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toString().capitalizeFirstLetterOfEachWord(),
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
         fontSize: size,
          fontWeight: FontWeight.w500,
          color: Colors.black),
    );
  }
}
