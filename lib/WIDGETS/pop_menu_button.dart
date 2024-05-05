import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/WIDGETS/Texts/helper_texts.dart';
import 'package:seller_app/main.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final Function(String) onItemSelected;
  final String text1;
  final String text2;
  final IconData iconData1;
  final IconData iconData2;
  final IconData? mainIcon;

  const CustomPopupMenuButton({
    super.key,
    required this.text1,
    this.mainIcon,
    required this.text2,
    required this.onItemSelected,
    required this.iconData1,
    required this.iconData2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPopupMenu(context);
      },
      child: text1 != "Single Preset"
          ? Icon(mainIcon)
          : Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              width: 90,
              decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20)

              ),
              child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HelperText1(
                                      text: "Add",
                                      color: Colors.white70,
                                      fontSize: 15,
                                    ),
                      Icon(Icons.add,color: Colors.white70,)

                    ],
                  )),
            ),
    );
  }

  void _showPopupMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      color: Colors.white,
      context: context,
      position: position,
      items: [
        buildPopupMenuItem(
          value: text1,
          icon: iconData1,
          title: text1,
        ),
        buildPopupMenuItem(
          value: text2,
          icon: iconData2,
          title: text2,
        ),
      ],
    ).then((value) {
      if (value != null) {
        onItemSelected(value);
      }
    });
  }

  PopupMenuItem<String> buildPopupMenuItem({
    required String value,
    required IconData icon,
    required String title,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: HelperText1(
          text: title,
          color: Colors.black87,
          fontSize: 15,
        ),
        dense: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
