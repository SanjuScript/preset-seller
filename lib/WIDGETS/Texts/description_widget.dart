import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DescriptionText extends StatelessWidget {
  final String description;
  final void Function() ontap;
  const DescriptionText(
      {super.key, required this.description, required this.ontap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              minHeight: size.height * 0.08,
              minWidth: size.width * 0.90,
              maxHeight: size.height * 0.30,
              maxWidth: size.width * 0.90,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200]!,
                  offset: const Offset(2, -2),
                  blurRadius: 5,
                ),
                BoxShadow(
                  color: Colors.grey[200]!,
                  offset: const Offset(-2, 2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'hando',

                ),
                textAlign: TextAlign.start,
                // overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
//  Text(
//                     "About your account",
//                     maxLines: 2,
//                     style: TextStyle(
//                       fontSize: size.width * 0.04,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                       fontFamily: 'hando',
//                     ),
//                     textAlign: TextAlign.start,
//                     overflow: TextOverflow.ellipsis,
//                   ),