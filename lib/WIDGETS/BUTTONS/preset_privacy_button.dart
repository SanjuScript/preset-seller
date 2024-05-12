import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';

class PresetPrivacy extends StatelessWidget {
  const PresetPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/presetPolicy");
      },
      child: Container(
        height: size.height * .05,
        width: size.width * .8,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.privacy_tip_rounded,
                color: Colors.blue[400],
                size: size.width * .06,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "See this rules before uploading presets !!".capitalizeFirstLetterOfEachWord(),
                style: const TextStyle(
                    // fontFamily: Getfont.rounder,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
