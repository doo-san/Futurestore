import 'package:get/get.dart';
import '../servers/repository.dart';
import '../models/all_product_model.dart';

class HomeProductsController extends GetxController {
  final Repository _repo = Repository();

  var products = <Data>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      final result = await _repo.getAllProduct(page: 1);
      products.assignAll(result);
    } catch (e) {
      print("HOME PRODUCTS ERROR => $e");
    } finally {
      isLoading.value = false;
    }
  }
}
