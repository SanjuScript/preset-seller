import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/API/notification_handling_api.dart';
import 'package:seller_app/PROVIDERS/bottom_nav_provider.dart';
import 'package:seller_app/SCREENS/home_page.dart';
import 'package:seller_app/SCREENS/profile_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;
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
    pages = [const HomeScreen(), const ProfilePage()];
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
    return PopScope(
      canPop: selectedIndex == 0,
      onPopInvoked: (didPop) {
        if (selectedIndex != 0) {
          navigateToPage(0);
        }
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
        bottomNavigationBar: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: const Color(0xFFFAFAFA),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.085,
                child: BottomNavigationBar(
                  showUnselectedLabels: false,
                  unselectedItemColor: const Color.fromARGB(255, 63, 63, 63),
                  selectedFontSize: MediaQuery.of(context).size.height * 0.01,
                  selectedItemColor: Colors.deepPurple[400],
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
