import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/PROVIDERS/auth_page_controller_provider.dart';


class BothScreensView extends StatefulWidget {
  const BothScreensView({super.key});

  @override
  State<BothScreensView> createState() => _BothScreensViewState();
}

class _BothScreensViewState extends State<BothScreensView> {
  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<AuthPageControllerProvider>(context);
    return WillPopScope(
      onWillPop: () async{
        if (pageProvider.currentIndex != 0) {
          pageProvider.navigateToPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              if (pageProvider.currentIndex > 0) {
                pageProvider.navigateToPage(pageProvider.currentIndex - 1);
              }
            } else if (details.primaryVelocity! < 0) {
              if (pageProvider.currentIndex < pageProvider.pages.length - 1) {
                pageProvider.navigateToPage(pageProvider.currentIndex + 1);
              }
            }
          },
          child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: PageView.builder(
                controller: pageProvider.pageController,
                onPageChanged: (index) {
                  pageProvider.onPageChange(index);
                },
                itemCount: pageProvider.pages.length,
                itemBuilder: (context, index) {
                  // Load data for the page at 'index' here, asynchronously if needed.
                  return pageProvider.pages[index];
                },
              )),
        ),
      ),
    );
  }
}
