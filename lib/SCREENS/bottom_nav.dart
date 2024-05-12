import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/API/notification_handling_api.dart';
import 'package:seller_app/PROVIDERS/bottom_nav_provider.dart';
import 'package:seller_app/SCREENS/home_page.dart';
import 'package:seller_app/SCREENS/order_details/orders.dart';
import 'package:seller_app/SCREENS/profile_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 1;
  late PageController pageController;
  late List<Widget> pages = [];
  void onPageChange(int index) {
    final provider = context.read<BottomNavProvider>();
    provider.selectedIndex = index;
  }

  void navigateToPage(int index) {
    final provider = context.read<BottomNavProvider>();
    provider.navigateToPage(pageController, index);
  }

  @override
  void initState() {
    super.initState();
    final provider = context.read<BottomNavProvider>();
    pageController = provider.createPageController();
    pages = [
      const OrdersPage(),
      const HomeScreen(),
      const ProfilePage(),
    ];
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Bottom Nav rebuilded');
    final provider = context.watch<BottomNavProvider>();
    log(provider.selectedIndex.toString());
    return PopScope(
      canPop: provider.selectedIndex == 1,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        navigateToPage(1);
      },
      child: Scaffold(
        extendBody: true,
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              if (selectedIndex > 0) {
                navigateToPage(selectedIndex - 1);
              }
            } else if (details.primaryVelocity! < 0) {
              if (selectedIndex < pages.length - 1) {
                navigateToPage(selectedIndex + 1);
              }
            }
          },
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: PageView(
              controller: pageController,
              onPageChanged: onPageChange,
              children: pages,
            ),
          ),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: const Color(0xFFFAFAFA),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.085,
            child: BottomNavigationBar(
              showUnselectedLabels: false,
              unselectedItemColor: Color.fromARGB(255, 148, 148, 148),
              selectedFontSize: MediaQuery.of(context).size.height * 0.01,
              selectedItemColor: Colors.black87,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              currentIndex: provider.selectedIndex,
              onTap: (int index) {
                provider.selectedIndex = index;
                if (index != 0) {
                  // NotificationApi.showPresetUploadedNotification();
                }

                navigateToPage(index);
              },
              items: <BottomNavigationBarItem>[
                bottomNavBarMethod(
                  bottomNavBarIcon: Icons.receipt_long_rounded,
                  bottomNavBarLabel: 'Orders',
                ),
                bottomNavBarMethod(
                  bottomNavBarIcon: Icons.home,
                  bottomNavBarLabel: 'Home',
                ),
                bottomNavBarMethod(
                  bottomNavBarIcon: Icons.person_2_rounded,
                  bottomNavBarLabel: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem bottomNavBarMethod({
    required IconData bottomNavBarIcon,
    required String bottomNavBarLabel,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(bottomNavBarIcon),
      label: bottomNavBarLabel,
    );
  }
}
