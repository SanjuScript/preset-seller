import 'package:flutter/material.dart';
import 'package:seller_app/CONSTANTS/fonts.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';

class GetPresetUploadingButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final Color color;
  final Color textColor;
  const GetPresetUploadingButton(
      {super.key,
      required this.onPressed,
      this.textColor =  Colors.white70,
      this.color = Colors.black87,
      required this.text});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: size.height * .09,
        width: size.width * .85,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text.capitalizeFirstLetterOfEachWord(),
            style: TextStyle(
              fontSize: size.width * 0.06,
              overflow: TextOverflow.ellipsis,
              color:textColor,
              fontFamily: Getfont.rounder,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
