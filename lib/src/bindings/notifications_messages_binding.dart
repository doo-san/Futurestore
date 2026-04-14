import 'package:get/get.dart';
import '../controllers/all_notifications_controller.dart';
import '../controllers/chat_controller.dart';

class NotificationsMessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllNotificationsController>(
        () => AllNotificationsController(),
        fenix: true);
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
  }
}
