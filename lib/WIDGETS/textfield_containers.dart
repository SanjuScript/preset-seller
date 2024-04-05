import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget widget;
  const TextFieldContainer({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: size.height * 0.07,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: widget,
      ),
    );
  }
}

