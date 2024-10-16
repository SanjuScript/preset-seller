import 'package:flutter/material.dart';
import 'package:seller_app/CONTROLLER/user_auth_controller.dart';
import 'package:seller_app/ROUTER/page_router.dart';
import 'package:seller_app/SCREENS/bottom_nav.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/DIALOGUE_UTILS/custom_dialogue.dart';

void showLogoutDialogue({
  required BuildContext context,
}) {
  CustomBlurDialog.show(
    context: context,
    title: 'Confirm Logout',
    content: 'Are you sure you want to log out?',
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          'Cancel',
          style: TextStyle(color: Colors.deepPurple, fontSize: 18),
        ),
      ),
      TextButton(
        onPressed: () async {
          Navigator.of(context).pop();
          await AuthController.signOut(context);
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),
          );
          AppRouter.router.go('/');
        },
        child: const Text(
          'Log out',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      ),
    ],
  );
}
