import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/API/notification_handling_api.dart';
import 'package:seller_app/PROVIDERS/auth_page_controller_provider.dart';
import 'package:seller_app/PROVIDERS/bottom_nav_provider.dart';
import 'package:seller_app/PROVIDERS/page_view_controller_provider.dart';
import 'package:seller_app/PROVIDERS/password_visibility_provider.dart';
import 'package:seller_app/AUTHENTICATION/authentication_page.dart';
import 'package:seller_app/PROVIDERS/permission_provider.dart';
import 'package:seller_app/PROVIDERS/policy_status_checking_provider.dart';
import 'package:seller_app/PROVIDERS/user_profile_provider.dart';
import 'package:seller_app/SCREENS/bottom_nav.dart';
import 'package:seller_app/SCREENS/lightroom_presets/preset_view_page.dart';
import 'package:seller_app/SCREENS/lightroom_presets/presets_list.dart';
import 'package:seller_app/SCREENS/preset_uploading/preset_uploading_policy.dart';
import 'package:seller_app/firebase_options.dart';

final GlobalKey<NavigatorState> authPageControllerKey = GlobalKey();
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    log("Some notification Received in background...");
  }
}

// to handle notification on foreground on web platform
void showNotification({required String title, required String body}) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"))
      ],
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
  await NotificationApi.init();
  await NotificationApi.localNotiInit();
  await NotificationApi.getDeviceToken();
  await dotenv.load(fileName: ".env");
  // DependencyInjection.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      log("Background Notification Tapped");
      // handleNotificationTapped(message);
      log(message.toMap().toString());
      navigatorKey.currentState!.pushNamed("/home");
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    log("Got a message in foreground");
    if (message.notification != null) {
      if (kIsWeb) {
        showNotification(
            title: message.notification!.title!,
            body: message.notification!.body!);
      } else {
        NotificationApi.showSimpleNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            payload: payloadData);
      }
    }
  });

  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    Future.delayed(const Duration(seconds: 1), () {
      log(message.data.toString());
    });
  }

  UserProfileProvider userProfile = UserProfileProvider();
  userProfile.getTotalPresetsCount();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => PasswordVisibilityProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => AuthPageControllerProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => PolicyStatusProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => BottomNavProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => PermissionProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => PresetsPageViewContollerProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => userProfile,
      ),
    ],
    child: MyApp(),
  ));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(0, 0, 0, 0),
      statusBarIconBrightness: Brightness.light,
      // statusBarBrightness: Brightness.dark
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        "/home": (context) => const BottomNav(),
        "/presetList": (context) => const PresetListPage(),
        "/presetView": (context) => const PresetViewPage(),
        "/presetPolicy": (context) => const PresetUploadPolicy(),
      },
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const BottomNav();
          } else {
            return const AuthenticationPage();
          }
        },
      ),
    );
  }
}
