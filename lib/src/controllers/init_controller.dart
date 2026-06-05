import 'dart:io';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:yoori_ecommerce/config.dart';
import 'package:yoori_ecommerce/src/_route/routes.dart';


class InitController extends GetxController {

  void configOneSignal() {
    // OneSignal ne supporte pas macOS
    if (Platform.isMacOS) return;
    OneSignal.initialize(Config.oneSignalAppId);
    OneSignal.Debug.setLogLevel(OSLogLevel.none);
    OneSignal.Notifications.requestPermission(true);
    OneSignal.Notifications.addClickListener((_) {
      Get.toNamed(Routes.notificationsMessages);
    });
  }

  @override
  void onInit() async {
    configOneSignal();
    super.onInit();
  }
}
