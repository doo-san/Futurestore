import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:yoori_ecommerce/config.dart';


class InitController extends GetxController {

  void configOneSignal() {
    OneSignal.initialize(Config.oneSignalAppId);
    OneSignal.Debug.setLogLevel(OSLogLevel.none);
    // Demande la permission push (indispensable iOS + Android 13+)
    OneSignal.Notifications.requestPermission(true);
  }

  @override
  void onInit() async {
    configOneSignal();
    super.onInit();
  }
}
