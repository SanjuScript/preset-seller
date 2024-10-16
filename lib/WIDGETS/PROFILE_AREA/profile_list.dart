import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/CONSTANTS/assets.dart';
import 'package:seller_app/CUSTOM/font_controller.dart';
import 'package:seller_app/EXTENSION/color_extension.dart';
import 'package:seller_app/MODEL/admin_data_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileListViewer extends StatelessWidget {
  final String desc;
  final Widget leading;
  final bool threeLine;
  final String text;
  final void Function() onTap;
  const ProfileListViewer(
      {super.key,
      required this.desc,
      required this.leading,
      required this.text,
      this.threeLine = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return ListTile(
      isThreeLine: threeLine,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: Colors.black87,
      onTap: onTap,
      title: Text(
        text,
        style: PerfectTypogaphy.regular.copyWith(
          color: "#eff3fc".toColor(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      leading: leading,
      subtitle: Text(
        desc ?? '',
        
        maxLines: 1,
        
        style: PerfectTypogaphy.regular.copyWith(
          color: "#eff3fc".toColor(),
          fontSize: size.width * 0.034,
          overflow: TextOverflow.ellipsis,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
