import 'dart:developer';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_app/API/notification_handling_api.dart';
import 'package:seller_app/AUTHENTICATION/authentication_page.dart';
import 'package:seller_app/MODEL/preset_data_model.dart';
import 'package:seller_app/SCREENS/bottom_nav.dart';
import 'package:seller_app/SCREENS/lightroom_presets/preset_view_page.dart';
import 'package:seller_app/SECURITY/storage_manager.dart';
import 'package:seller_app/WIDGETS/DIALOGUE/notification_permimssion_dialogue.dart';
import 'package:seller_app/main.dart';

GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: navigationKey,
    observers: [FirebaseAnalyticsObserver(analytics: firebaseAnalytics)],
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => FutureBuilder<bool>(
          future: PerfectStateManager.checkAuthState(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: CircularProgressIndicator(),
              );
            }

            final bool isAuthenticated = snapshot.data ?? false;
            log(isAuthenticated.toString());
            if (isAuthenticated) {
              NotificationApi.getDeviceToken();
              checkNotificationPermission(context);
              return const BottomNav();
            } else {
              return const AuthenticationPage();
            }
          },
        ),
      ),
      GoRoute(
        path: '/presetView',
        builder: (context, state) {
          final presetModel = state.extra as PresetModel;
          return PresetViewPage(presetModel: presetModel);
        },
      ),
    ],
  );
}

Future<void> checkNotificationPermission(BuildContext context) async {
  bool isNotificationEnabled =
      await NotificationApi.checkNotificationPermission();
  if (!isNotificationEnabled) {
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return const NotificationPermissionDialog();
      },
    );
  }
}
