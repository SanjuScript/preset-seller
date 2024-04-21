import 'package:flutter/material.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';

class GetPresetEditButton extends StatelessWidget {
  final void Function() onPressed;
  final bool status;
  final bool isDeleteButton;
  const GetPresetEditButton(
      {super.key,
      required this.onPressed,
      required this.status,
      required this.isDeleteButton});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: size.height * .09,
        width: size.width * .90,
        decoration: BoxDecoration(
          color: !isDeleteButton ? Colors.black87: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: isDeleteButton
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    status ? Icon(Icons.delete) : SizedBox(),
                    SizedBox(width: 20),
                    Text(
                      status
                          ? "delete all".capitalizeFirstLetterOfEachWord()
                          : "Reviewing...",
                      style: TextStyle(
                        fontSize: size.width * 0.06,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black87,
                        fontFamily: 'hando',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_document,
                      color: Colors.white54,
                    ),
                    Text(
                      "Edit ".toUpperCase(),
                      style: TextStyle(
                        fontSize: size.width * 0.06,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white,
                        fontFamily: 'hando',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
