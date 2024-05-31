import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dits/controller/signup_controller.dart';

// Check network connectivity
Future<bool> hasNetworkConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}

class NetworkSyncService {
  static Future<void> startService() async {
    // This method checks for network connectivity every minute
    while (true) {
      await Future.delayed(Duration(microseconds: 10));
      if (await hasNetworkConnection()) {
        await syncLocalDataToFirestore();
      }
    }
  }
}

