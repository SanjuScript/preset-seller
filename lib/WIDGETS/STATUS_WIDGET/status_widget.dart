import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';

class StatusDisplayer extends StatelessWidget {
  final String status;
  const StatusDisplayer({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * .03,
      width: size.width * .25,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(.6),
          borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: HelperText1(
                text: status == "pending"
                    ? "In review"
                    : status == "rejected"
                        ? "Rejected"
                        : '',
                fontSize: size.width * .035,
                color: const Color.fromRGBO(0, 0, 0, 0.867),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
