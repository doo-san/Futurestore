import 'package:get/get.dart';
import '../controllers/cart_content_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartContentController>(
          () => CartContentController(),
      fenix: true,
    );
  }
}