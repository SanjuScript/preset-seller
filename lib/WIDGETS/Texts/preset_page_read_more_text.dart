import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:seller_app/CUSTOM/font_controller.dart';

class GetReadMoreText extends StatelessWidget {
  final String text;
  const GetReadMoreText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ReadMoreText(
        text,
        textAlign: TextAlign.justify,
        trimMode: TrimMode.Line,
        trimLines: 2,
        
        colorClickableText: Colors.green,
        trimCollapsedText: 'Show more',
        trimExpandedText: 'Show less',
        moreStyle: TextStyle(
          
          fontSize: size.width * 0.04,
          color: Colors.green[600],
          fontWeight: FontWeight.bold,
        ),
        lessStyle: TextStyle(
          fontSize: size.width * 0.04,
          color: Colors.green[600],
          fontWeight: FontWeight.bold,
        ),
        style: TextStyle(
          fontSize: size.width * 0.04,
          fontFamily: 'monuse',
          color: Colors.black54,
        ),
      ),
    );
  }
}
