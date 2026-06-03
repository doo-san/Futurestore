import 'package:get/get.dart';
import '../servers/repository.dart';
import '../models/product_details_model.dart';
import '../utils/constants.dart';

class DetailsPageController extends GetxController {

  final Repository _repository = Repository();

  /// loading state
  bool isLoading = false;

  /// product details
  ProductDetailsModel? productDetail;

  /// important pour éviter reload infini
  String? currentProductId;

  /// charger les détails
  Future<void> getProductDetails(String productId) async {

    try {

      isLoading = true;
      update();

      currentProductId = productId;

      printLog("LOAD PRODUCT DETAILS ID = $productId");

      final result =
      await _repository.getProductDetails(int.parse(productId));

      productDetail = result;

      printLog("PRODUCT DETAILS LOADED");

    } catch (e) {

      printLog("DETAILS ERROR: $e");

    }

    isLoading = false;
    update();

  }

}
