import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInterceptor {
  static final Connectivity connectivity = Connectivity();

  static Future<bool> isNetworkAvailable() async {
    var connectivityResult = await connectivity.checkConnectivity();
    bool getStatus = false;
    for (var result in connectivityResult) {
      getStatus = result != ConnectivityResult.none;
    }
    log(getStatus.toString());
    return getStatus;
  }
}
