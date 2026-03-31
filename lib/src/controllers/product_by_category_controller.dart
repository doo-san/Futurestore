import 'package:get/get.dart';
import '../servers/repository.dart';
import '../models/product_by_category_model.dart';

class ProductByCategoryController extends GetxController {

  final Repository _repository = Repository();

  RxList<CategoryProductData> products = <CategoryProductData>[].obs;

  RxBool isLoading = false.obs;

  int page = 1;
  bool hasMore = true;

  Future<void> loadProducts(int categoryId) async {

    if (!hasMore) return;

    try {

      isLoading(true);

      print("Loading category: $categoryId page: $page");

      final result = await _repository.getProductsByCategory(
        categoryId: categoryId,
        page: page,
      );

      if (result.isEmpty) {
        hasMore = false;
      } else {
        products.addAll(result);
        page++;
      }

      print("Products loaded: ${products.length}");

    } catch (e) {

      print("ERROR loading products: $e");

    } finally {

      isLoading(false);

    }

  }

  void reset(int categoryId) {

    products.clear();

    page = 1;

    hasMore = true;

    loadProducts(categoryId);

  }

}

