import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seller_app/API/notification_handling_api.dart';
import 'package:seller_app/FUNCTIONS/admin_data_controller_unit.dart';
import 'package:seller_app/ROUTER/page_router.dart';

class NotificationRouter {
  static void routeNotification(
      NotificationResponse notificationResponse) async {
    final payload = notificationResponse.payload;
    switch (payload) {
      case "preset_uploaded":
      case "preset_upload_failure":
        AppRouter.router.go("/presetList");
        break;
      case "withdrawel_pending":
        AppRouter.router.go("/wallet");
        break;
      default:
         if (payload != null && payload.startsWith("preset_cover")) {
          final docId = payload.split("_").last;
          final presetModel =
              await DataController.getPresetModelForDocId(docId);
          AppRouter.router.go("/presetView", extra: presetModel);
        } else {
          AppRouter.router.go("/");
        }
        break;
    }
  }
}
