import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seller_app/PROVIDERS/auth_page_controller_provider.dart';
import 'package:seller_app/PROVIDERS/bottom_nav_provider.dart';
import 'package:seller_app/PROVIDERS/page_view_controller_provider.dart';
import 'package:seller_app/PROVIDERS/password_visibility_provider.dart';
import 'package:seller_app/AUTHENTICATION/authentication_page.dart';
import 'package:seller_app/PROVIDERS/permission_provider.dart';
import 'package:seller_app/PROVIDERS/policy_status_checking_provider.dart';
import 'package:seller_app/SCREENS/bottom_nav.dart';
import 'package:seller_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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
    ],
    child: MyApp(),
  ));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(0, 0, 0, 0),
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: CircularProgressIndicator());
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
