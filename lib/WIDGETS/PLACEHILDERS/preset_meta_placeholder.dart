import 'package:flutter/material.dart';

class PresetMetaPlaceHolder extends StatelessWidget {
  final void Function() onTap;
  const PresetMetaPlaceHolder({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height * .15,
      width: size.width * .26,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        child: const Center(
          child: Text(
            '+ Add Image',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
