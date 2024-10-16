import 'package:flutter/material.dart';
import 'package:seller_app/CONSTANTS/fonts.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/EXTENSION/color_extension.dart';

class GetPresetUploadingButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final Color color;
  final Color textColor;
  const GetPresetUploadingButton(
      {super.key,
      required this.onPressed,
      this.textColor = Colors.white70,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.upload_rounded,
                size: size.width * .062,
                color: "#eff3fc".toColor(),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                text.capitalizeFirstLetterOfEachWord(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: "#eff3fc".toColor(), fontSize: size.width * .060),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
