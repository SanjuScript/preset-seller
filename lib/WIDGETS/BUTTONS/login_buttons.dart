import 'package:flutter/material.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';

class AuthenticationButton extends StatelessWidget {
  final void Function() onTap;
  final Color color;
  final String text;
  const AuthenticationButton(
      {super.key,
      required this.onTap,
       this.color = Colors.white24,
      required this.text});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: onTap,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      child: Container(
        height: size.height * .072,
        width: size.width,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: HelperText1(
            text: text,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

Widget authConfirmButton(
    {required BuildContext context,
    required void Function() onTap,
    Color color = Colors.white24,
    String text = 'Login'}) {
  final ht = MediaQuery.of(context).size.height;
  final wt = MediaQuery.of(context).size.width;
  return InkWell(
    onTap: onTap,
    overlayColor: MaterialStateProperty.all(Colors.transparent),
    child: Container(
      height: ht * .072,
      width: wt,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: color.withOpacity(.5),
          borderRadius: BorderRadius.circular(20)),
      child: Center(child: HelperText1(text: text, color: Colors.black87)),
    ),
  );
}
