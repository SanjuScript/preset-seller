import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppealScreen extends StatelessWidget {
  const AppealScreen({
    super.key,
  });

  void sendAppealByEmail(BuildContext context) async {
    const String emailAddress = 'mozmusicfounder@gmail.com';
    const String subject = 'Appeal for Account Disablement';

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      query: 'subject=$subject',
    );

    log(emailLaunchUri.toString());

    if (await canLaunchUrlString(emailLaunchUri.toString())) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch email app';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appeal Account Disablement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Your account has been temporarily disabled by the administrator for violating community guidelines. Please provide a detailed appeal below:',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20),
              const Text(
                'We value your input and are committed to providing a fair review process. Please open your email app and send an appeal to the address provided below. We will respond to your appeal as soon as possible.',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.deepPurple,
                    fontFamily: 'hando'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your data is safe and will not be deleted. Once your account is reactivated, you will have access to all your information.',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Text(
                'Attention: Your account is currently marked for deletion. According to our policy, if no activity is recorded within the next 90 days, your account will be permanently deleted from our system. To prevent this from happening, please take appropriate action by logging into your account and engaging in any necessary activity. If you believe this is an error or have any questions, please contact our support team immediately. We value your presence and want to ensure your continued satisfaction with our services.',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.red[300],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => sendAppealByEmail(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // text color
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Open Email App and Send Appeal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
