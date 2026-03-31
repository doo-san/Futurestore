import 'package:get/get.dart';
import 'package:yoori_ecommerce/src/_route/routes.dart';
import 'package:yoori_ecommerce/src/servers/repository.dart';

class ChangePasswordController extends GetxController{
  var isVisibleA = true.obs;
  var isVisibleB = true.obs;
  var isVisibleC = true.obs;
  var isLoading = false.obs;

  void isVisibleUpdateA() {
    isVisibleA.value = !isVisibleA.value;
  }
  void isVisibleUpdateB() {
    isVisibleB.value = !isVisibleB.value;
  }
  void isVisibleUpdateC() {
    isVisibleC.value = !isVisibleC.value;
  }

  Future changePassword({String? currentPass,String? newPass,String? confirmPass}) async{
    isLoading.value = true;
    await Repository()
        .postChangePassword(
        currentPass: currentPass,
        newPass: newPass,
        confirmPass: confirmPass)
        .then((value) {
      if (value) {
        Get.offNamed(Routes.dashboardScreen);
          isLoading.value = false;
      } else {
          isLoading.value = false;
      }
    });
  }
}
