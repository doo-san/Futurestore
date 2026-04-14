import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoori_ecommerce/src/widgets/loader/shimmer_products.dart';
import '../../../controllers/home_screen_controller.dart';
import '../../../models/product_by_shop_model.dart';
import '../../../utils/app_theme_data.dart';
import '../../../utils/constants.dart';
import '../../../widgets/product_card_widgets/product_card.dart';
import '../../../servers/repository.dart';

class ProductByShop extends StatefulWidget {
  const ProductByShop({super.key, required this.id, this.shopName});
  final int id;
  final String? shopName;

  @override
  State<ProductByShop> createState() => _ProductByShopState();
}

class _ProductByShopState extends State<ProductByShop> {
  ProductByShopModel productByShopModel = ProductByShopModel();
  final homeController = Get.put(HomeScreenController());

  Future getTodayDealData() async {
    printLog(widget.id);
    productByShopModel = await Repository().getProductByShop(widget.id);
    // setState(() {});
  }

  @override
  void initState() {
    getTodayDealData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return productByShopModel.data == null
        ? const Scaffold(body: ShimmerProducts())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFFF0008),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                }, 
              ),
              centerTitle: true,
              title: Text(
                widget.shopName.toString(),
                style: AppThemeData.headerTextStyle_16.copyWith(color: Colors.white),
              ),
            ),
            body: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              shrinkWrap: true,
              itemCount: productByShopModel.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemBuilder: (context, index) {
                return ProductCard(
                  dataModel: productByShopModel,
                  index: index,
                );
              },
            ),
          );
  }
}
