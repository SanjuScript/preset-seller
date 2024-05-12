import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';


// class NetworkController extends GetxController {
//   final Connectivity _connectivity = Connectivity();

//   @override
//   void onInit() {
//     super.onInit();
//     _connectivity.onConnectivityChanged.listen(_updateStatus);
//   }

//   void _updateStatus(List<ConnectivityResult> connectivityResults) {
//     ConnectivityResult connectivityResult = connectivityResults.isNotEmpty ? connectivityResults.first : ConnectivityResult.none;
//     if (connectivityResult == ConnectivityResult.none) {
//       Get.rawSnackbar(
//           messageText: Text(
//             'Please Connect To The Internet'.toUpperCase(),
//             style: const TextStyle(color: Colors.white, fontSize: 14),
//           ),
//           isDismissible: false,
//           duration: const Duration(seconds: 1),
//           backgroundColor: Colors.black87,
//           icon: const Icon(
//             Icons.wifi_off_rounded,
//             color: Colors.white70,
//             size: 35,
//           ),
//           margin: EdgeInsets.zero,
//           snackStyle: SnackStyle.GROUNDED);
//     } else {
//       if (Get.isSnackbarOpen) {
//         Get.closeCurrentSnackbar();
//       }
//     }
//   }
// }

class NetworkInterceptor {
  final Connectivity _connectivity = Connectivity();

  Future<bool> isNetworkAvailable() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<dynamic> interceptRequest(Future<dynamic> Function() request) async {
    try {
      if (await isNetworkAvailable()) {
        return await request();
      } else {
        throw NetworkException("No internet connection");
      }
    } catch (e) {
      throw NetworkException("Network error: $e");
    }
  }
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}
