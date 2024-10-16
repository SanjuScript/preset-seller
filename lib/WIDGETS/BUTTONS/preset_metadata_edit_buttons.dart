import 'package:flutter/material.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';
import 'package:seller_app/EXTENSION/color_extension.dart';

class GetPresetEditButton extends StatelessWidget {
  final void Function() onPressed;
  final bool status;
  const GetPresetEditButton({
    super.key,
    required this.onPressed,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: size.height * .09,
        width: size.width * .90,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.edit_square,
                color: "#eff3fc".toColor(),
              ),
              SizedBox(width: 5),
              Text(
                "Modify",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: "#eff3fc".toColor(),
                      fontSize: size.width * 0.06,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
