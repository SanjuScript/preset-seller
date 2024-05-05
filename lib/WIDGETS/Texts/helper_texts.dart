import 'package:flutter/material.dart';
import 'package:seller_app/CONSTANTS/fonts.dart';

class HelperText1 extends StatelessWidget {
  final String text;
  final Color color;
  final TextDecoration decoration;
  final double fontSize;
  const HelperText1(
      {super.key,
      required this.text,
      this.color = Colors.white,
      this.decoration = TextDecoration.none,
      this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
        color: color,
        decoration: decoration,
        fontFamily: Getfont.rounder,
      ),
      textAlign: TextAlign.center,
    );
  }
}
class HelperText3 extends StatelessWidget {
  final String text;
  final Color color;
  final TextDecoration decoration;
  final double fontSize;
  const HelperText3(
      {super.key,
      required this.text,
      this.color = Colors.white,
      this.decoration = TextDecoration.none,
      this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        decoration: decoration,
        fontFamily: Getfont.rounder,
      ),
      textAlign: TextAlign.start,
    );
  }
}


