import 'package:flutter/material.dart';
import 'package:seller_app/AUTHENTICATION/login_page.dart';
import 'package:seller_app/AUTHENTICATION/sign_up_page.dart';

class AuthPageControllerProvider with ChangeNotifier {
  late List<Widget> pages;
  int currentIndex = 0;
  late PageController pageController;

  AuthPageControllerProvider() {
    pageController = PageController(initialPage: 0);
    pages = const [
      LoginPage(),
      SignUpPage(),
    ];
  }

  void navigateToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void onPageChange(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
