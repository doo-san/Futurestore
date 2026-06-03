import 'dart:async';

import 'package:get/state_manager.dart';
import 'package:yoori_ecommerce/src/models/search_product_model.dart';
import 'package:yoori_ecommerce/src/servers/repository.dart';
import 'package:yoori_ecommerce/src/utils/analytics_helper.dart';
import 'package:yoori_ecommerce/src/utils/constants.dart';

// Taille d'une page retournée par le backend (api_paginate = 15)
const int _kPageSize = 15;

class ProductSearchController extends GetxController {
  final Rx<SearchProductModel> _searchResult = SearchProductModel().obs;
  SearchProductModel get searchResult => _searchResult.value;
  final RxBool _isSearching = false.obs;
  bool get isSearching => _isSearching.value;
  final RxBool _isSearchFieldEmpty = true.obs;
  bool get isSearchFieldEmpty => _isSearchFieldEmpty.value;
  final RxBool _isLoadingMore = false.obs;
  bool get isLoadingMore => _isLoadingMore.value;
  final RxBool _hasMoreData = false.obs;
  bool get hasMoreData => _hasMoreData.value;

  int _currentPage = 1;
  String _lastSearchValue = '';

  Future<void> search(String searchValue) async {
    if (searchValue.trim().isEmpty) return;
    _currentPage = 1;
    _lastSearchValue = searchValue;
    _hasMoreData(false);
    _isSearching(true);
    try {
      final value = await Repository().getSearchProducts(searchKey: searchValue, page: 1);
      if (value.data != null && value.data!.isNotEmpty) {
        _searchResult.value = value;
        _hasMoreData(_hasNextPage(value));
        AnalyticsHelper().setAnalyticsData(
            screenName: "SearchScreen",
            eventTitle: "Search",
            additionalData: {"searchTag": searchValue});
      } else {
        _searchResult.value = SearchProductModel()..data = [];
        _hasMoreData(false);
      }
    } catch (e) {
      printLog('ProductSearchController search error: $e');
      _searchResult.value = SearchProductModel()..data = [];
      _hasMoreData(false);
    } finally {
      _isSearching(false);
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore.value || !_hasMoreData.value || _lastSearchValue.isEmpty) return;
    _isLoadingMore(true);
    _currentPage++;
    try {
      final value = await Repository().getSearchProducts(
          searchKey: _lastSearchValue, page: _currentPage);
      if (value.data != null && value.data!.isNotEmpty) {
        final merged = List<SearchProductData>.from(_searchResult.value.data ?? [])
          ..addAll(value.data!);
        _searchResult.value = SearchProductModel()
          ..success = value.success
          ..message = value.message
          ..data = merged
          ..currentPage = value.currentPage
          ..lastPage = value.lastPage;
        _hasMoreData(_hasNextPage(value));
      } else {
        _hasMoreData(false);
      }
    } catch (e) {
      printLog('ProductSearchController loadMore error: $e');
      _currentPage--;
    } finally {
      _isLoadingMore(false);
    }
  }

  bool _hasNextPage(SearchProductModel model) {
    if (model.lastPage != null && model.currentPage != null) {
      return model.currentPage! < model.lastPage!;
    }
    // Sans métadonnées de pagination, on suppose qu'il y a une page suivante
    // si la page actuelle contient autant d'éléments que la taille d'une page.
    return (model.data?.length ?? 0) >= _kPageSize;
  }

  void setIsSearchFieldEmpty(bool value) {
    _isSearchFieldEmpty(value);
  }

  @override
  void onInit() {
    _searchResult.value = SearchProductModel()..data = [];
    super.onInit();
  }
}
