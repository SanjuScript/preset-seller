import 'package:flutter/material.dart';
import 'package:seller_app/WIDGETS/Texts/helper_text2.dart';

class GetPresetNameGiver extends StatelessWidget {
  final String presetName;
  final String price;
  const GetPresetNameGiver(
      {super.key, required this.presetName, required this.price });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [GetText1(text: presetName,size: size.width * 0.07), GetText1(text: price,size: size.width * 0.07)],
      ),
    );
  }
}
