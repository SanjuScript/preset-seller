import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/API/auth_api.dart';
import 'package:seller_app/EXTENSION/capitalize.dart';

class EmailNotverified extends StatelessWidget {
  const EmailNotverified({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Send Email Verification link"),
              content: Text(
                  "Do you want to send a verification link to your ${AuthApi.auth.currentUser!.email} email address?"),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.red[100]),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No"),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(.2),
                  ),
                  onPressed: () {
                    AuthApi.auth.currentUser!.sendEmailVerification();
                    Fluttertoast.showToast(
                      msg: 'Verification link sent! Please check your email.',
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        height: size.height * .03,
        width: size.width * .6,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: Colors.red[400],
              size: size.width * .06,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Email verification Pending".capitalizeFirstLetterOfEachWord(),
              style: const TextStyle(
                  // fontFamily: Getfont.rounder,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
