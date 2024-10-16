import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/DATA/admin_data.dart';
import 'package:seller_app/ROUTER/notification_router.dart';

// final navigatorKey = GlobalKey<NavigatorState>();

class NotificationApi {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const String paymentChannelId = 'payment channel';

  static Future<void> init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
  }

  static Future<bool> checkNotificationPermission() async {
    bool notificationEnabled = false;
    if (!kIsWeb) {
      final NotificationSettings settings =
          await _firebaseMessaging.requestPermission();
      notificationEnabled =
          settings.authorizationStatus == AuthorizationStatus.authorized;
    }
    return notificationEnabled;
  }

  static Future<String?> getDeviceToken({int maxRetires = 3}) async {
    try {
      String? token;
      if (kIsWeb) {
        token = await _firebaseMessaging.getToken(
            vapidKey:
                "BPA9r_00LYvGIV9GPqkpCwfIl3Es4IfbGqE9CSrm6oeYJslJNmicXYHyWOZQMPlORgfhG8RNGe7hIxmbLXuJ92k");
        log("for web device token: $token");
      } else {
        token = await _firebaseMessaging.getToken();
        log("for android device token: $token");
      }
      log(token.toString());
      await AdminData.storeNotificationToken(token.toString());
      return token;
    } catch (e) {
      log("failed to get device token");
      if (maxRetires > 0) {
        Fluttertoast.showToast(msg: "try after 10 sec");
        await Future.delayed(const Duration(seconds: 10));
        return getDeviceToken(maxRetires: maxRetires - 1);
      } else {
        return null;
      }
    }
  }

  static Future<void> localNotiInit() async {
    const AndroidNotificationChannel paymentChannel =
        AndroidNotificationChannel(paymentChannelId, 'Payment Updates',
            description: "Notifications for payments");
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(paymentChannel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);

    // Android 13
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static void onNotificationTap(
      NotificationResponse notificationResponse) async {
    log("Notification Response : ${notificationResponse.payload}");
    NotificationRouter.routeNotification(notificationResponse);
  }

  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'com.ryanhansie.id', 'App updates',
      channelDescription: 'To notify the users about their data',
      importance: Importance.max,
      priority: Priority.high,
      // styleInformation: bigPictureStyleInformation,
      ticker: 'ticker',
    );

    //             const String filePath = GetAssetFile.rejectedIcon;
    //  BigPictureStyleInformation bigPictureStyleInformation =
    //     const BigPictureStyleInformation(FilePathAndroidBitmap(filePath),
    //         largeIcon: FilePathAndroidBitmap(filePath));

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);

    log(payload);
  }

  static Future<void> showPaymentNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      paymentChannelId,
      "Payment Updates",
      channelDescription: 'Notifications for payments',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);

    log(payload);
  }

  static void showProgressNotification({
    required String title,
    required String body,
    required int id,
  }) {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'com.ryanhansie.id',
      'progress',
      channelDescription: 'To notify the admins about their datas',
      importance: Importance.max,
      priority: Priority.high,
      // Do not set progress, maxProgress, and indeterminate here
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: 'upload_progress',
    );
  }

  static void updateProgressNotification({
    required int id,
    required double progress,
  }) {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'com.ryanhansie.id',
      'progress',
      channelDescription: 'To notify the admins about their datas',
      importance: Importance.max,
      priority: Priority.high,
      progress: progress.toInt(),
      maxProgress: 100,
      indeterminate: false,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    _flutterLocalNotificationsPlugin.show(
      id,
      'Uploading Presets',
      'Uploading in progress...',
      notificationDetails,
      payload: 'upload_progress',
    );
  }

  static void removeNotification({required int id}) {
    _flutterLocalNotificationsPlugin.cancel(id);
  }
}
// static void onNotificationTap(
//       NotificationResponse notificationResponse) async {
//     if (notificationResponse.payload == "preset_uploaded" ||
//         notificationResponse.payload == "preset_upload_failure") {
//       navigatorKey.currentState!.pushNamed("/presetList");
//     } else if (notificationResponse.payload!.startsWith("preset_cover")) {
//       String docId = notificationResponse.payload!.split("_").last;
//       log(docId);
//       PresetModel? presetModel =
//           await DataController.getPresetModelForDocId(docId);
//       navigatorKey.currentState!
//           .pushNamed("/presetView", arguments: {"presetModel": presetModel});
//     } else if (notificationResponse.payload == "withdrawel_pending") {
//       navigatorKey.currentState!.pushNamed("/wallet");
//     } else {
//       navigatorKey.currentState!.pushNamed("/home");
//     }
//   }