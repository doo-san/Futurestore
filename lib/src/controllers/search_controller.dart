import 'package:get/state_manager.dart';
import 'package:yoori_ecommerce/src/models/search_product_model.dart';
import 'package:yoori_ecommerce/src/servers/repository.dart';
import 'package:yoori_ecommerce/src/utils/analytics_helper.dart';


class ProductSearchController extends GetxController {
  final Rx<SearchProductModel> _searchResult = SearchProductModel().obs;
  SearchProductModel get searchResult => _searchResult.value;
  final RxBool _isSearching = false.obs;
  bool get isSearching => _isSearching.value;
  final RxBool _isSearchFieldEmpty = true.obs;
  bool get isSearchFieldEmpty => _isSearchFieldEmpty.value;

  Future<void> search(String searchValue) async {
    if (searchValue.trim().isEmpty) return;
    _isSearching(true);
    try {
      final value =
          await Repository().getSearchProducts(searchKey: searchValue);
      if (value.data != null && value.data!.isNotEmpty) {
        _searchResult.value = value;
        AnalyticsHelper().setAnalyticsData(
            screenName: "SearchScreen",
            eventTitle: "Search",
            additionalData: {"searchTag": searchValue});
      } else {
        searchResult.data = [];
      }
    } catch (_) {
      searchResult.data = [];
    } finally {
      _isSearching(false);
    }
  }

  void setIsSearchFieldEmpty(bool value) {
    _isSearchFieldEmpty(value);
  }

  @override
  void onInit() {
    searchResult.data = [];
    super.onInit();
  }
}
