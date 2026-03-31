import 'package:get/get.dart';
import 'package:yoori_ecommerce/src/controllers/auth_controller.dart';
import 'package:yoori_ecommerce/src/controllers/cart_content_controller.dart'; // 👈 AJOUT
import 'package:yoori_ecommerce/src/controllers/currency_converter_controller.dart';
import 'package:yoori_ecommerce/src/controllers/home_screen_controller.dart';
import 'package:yoori_ecommerce/src/controllers/payment_controller.dart';
import 'package:yoori_ecommerce/src/controllers/phone_auth_controller.dart';
import 'package:yoori_ecommerce/src/data/data_storage_service.dart';

class InitBindings implements Bindings {

  @override
  void dependencies() {

    /// Controllers globaux
    Get.put<AuthController>(AuthController(), permanent: true);

    Get.put<PhoneAuthController>(PhoneAuthController(), permanent: true);

    Get.put(StorageService(), permanent: true);

    Get.put<PaymentController>(PaymentController(), permanent: true);

    // ✅ AJOUT CRUCIAL
    Get.put<CartContentController>(
      CartContentController(),
      permanent: true,
    );

    Get.lazyPut(() => CurrencyConverterController(), fenix: true);

    Get.lazyPut(() => HomeScreenController(), fenix: true);
  }
}