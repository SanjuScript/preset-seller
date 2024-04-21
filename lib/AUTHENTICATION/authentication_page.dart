import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/AUTHENTICATION/both_view.dart';
import 'package:seller_app/CONSTANTS/assets.dart';
import 'package:seller_app/PROVIDERS/auth_page_controller_provider.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<AuthPageControllerProvider>(context);
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        backgroundColor: const Color(0xffD2E0FB),
        body: Stack(
          children: [
            SizedBox(
              // color: Colors.red,
              height: size.height * .35,
              child: Stack(
                children: [
                  Transform.translate(
                    offset: Offset(100, -100),
                    child: Transform.scale(
                      scale: 5,
                      child: Lottie.asset(GetAssetFile.loginBg,
                          frameRate: FrameRate.max,
                          repeat: true,
                          reverse: true),
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(color: Colors.transparent),
                  ),
                ],
              ),
            ),
            BothScreensView()
          ],
        ));
  }
}
