import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pagination_view/pagination_view.dart';

import '../../../models/product_by_category_model.dart';
import 'package:yoori_ecommerce/src/utils/responsive.dart';
import '../../../widgets/product_card_widgets/category_product_card.dart';
import '../../../servers/repository.dart';
import '../../../widgets/loader/shimmer_load_data.dart';
import '../../../widgets/loader/shimmer_products.dart';

class ProductByCategory extends StatefulWidget {
  const ProductByCategory({
    super.key,
    required this.id,
    this.title,
  });

  final int? id;
  final String? title;

  @override
  State<ProductByCategory> createState() => _ProductByCategoryState();
}

class _ProductByCategoryState extends State<ProductByCategory> {
  int page = 1;
  GlobalKey<PaginationViewState> key = GlobalKey<PaginationViewState>();

  Future<List<CategoryProductData>> getData(int offset) async {
    try {
      final products = await Repository().getProductsByCategory(
        categoryId: widget.id ?? 0,
        page: page,
      );
      page++;
      return products;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF0008),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          widget.title ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: PaginationView<CategoryProductData>(
        key: key,
        paginationViewType: PaginationViewType.gridView,
        pageFetch: getData,
        pullToRefresh: true,
        onEmpty: const Center(child: Text("Aucun produit trouvé")),
        onError: (_) => const Center(child: Text("Erreur de chargement")),
        bottomLoader: const ShimmerLoadData(),
        initialLoader: const ShimmerProducts(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile(context) ? 2 : 3,
          childAspectRatio: 0.62,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
        ),
        itemBuilder: (context, product, index) {
          return CategoryProductCard(
            dataModel: product,
            index: index,
          );
        },
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      ),
    );
  }
}
