import 'package:flutter/material.dart';

class ProfileElement extends StatelessWidget {
  final String text;
  final String count;
  final double rradius;
  final double ladius;
  const ProfileElement(
      {super.key,
      required this.text,
      required this.count,
       this.rradius = 25,
       this.ladius = 25});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * .11,
      width: size.width * .30,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(.1),
        borderRadius:  BorderRadius.only(
            bottomLeft: Radius.circular(ladius),
            bottomRight: Radius.circular(rradius)),
      ),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'hando',
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            count,
            style: TextStyle(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'rounder',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
