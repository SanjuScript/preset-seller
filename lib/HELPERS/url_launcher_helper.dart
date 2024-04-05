  import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLaunch{
  static Future<void> launchurl(BuildContext context, String? url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),);
    } else {
      throw 'Could not launch $url';
    }
  }
}