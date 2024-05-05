import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';

class ProfileEditingFields extends StatelessWidget {
  final bool isDesc;
  final bool isInsta;
  final TextEditingController controller;
  final String upText;
  final TextInputType textInputType;
  final String hintText;
  final bool isNeed;

  ProfileEditingFields(
      {super.key,
      required this.isDesc,
      required this.controller,
      required this.isNeed,
      required this.textInputType,
      required this.upText,
      required this.hintText,
      required this.isInsta});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: isNeed
                ? HelperText1(
                    text: upText,
                    color: Colors.black54,
                    fontSize: size.width * .05,
                  )
                : SizedBox()),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.8),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.justify,
              maxLength: isDesc
                  ? 450
                  : !isInsta
                      ? null
                      : 130,
              maxLines: isDesc
                  ? null
                  : isInsta
                      ? 1
                      : 1,
              keyboardType: textInputType,
              inputFormatters: [LengthLimitingTextInputFormatter(450)],
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.8),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: TextField(
              textInputAction: TextInputAction.newline,
              controller: controller,
              textAlign: TextAlign.justify,
              maxLength: 400,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              inputFormatters: [LengthLimitingTextInputFormatter(400)],
              decoration: InputDecoration(
                hintText: "Preset Description",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
