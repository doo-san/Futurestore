import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/favourite_controller.dart';
import '../../data/local_data_helper.dart';
import '../../_route/routes.dart';
import 'package:yoori_ecommerce/src/utils/app_tags.dart';
import '../../utils/app_theme_data.dart';
import 'package:yoori_ecommerce/src/utils/responsive.dart';
import '../../widgets/loader/shimmer_favorite.dart';
import 'favorite_product.dart';
import 'favorite_store.dart';

class FavoritesScreen extends StatelessWidget {
   FavoritesScreen({super.key});
  final controller = Get.put(FavouriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF0008),
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppTags.favorites.tr,
          style: AppThemeData.headerTextStyle_16.copyWith(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading) return const ShimmerFavorite();

        final token = LocalDataHelper().getUserToken();
        final isLoggedIn = token != null && token.isNotEmpty;

        if (!isLoggedIn || controller.data == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border_rounded,
                    size: 64.r, color: Colors.grey.shade300),
                SizedBox(height: 16.h),
                Text(
                  AppTags.pleaseLoginFirst.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile(context) ? 15.sp : 12.sp,
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.withOutLoginPage),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemeData.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 32.w, vertical: 12.h),
                  ),
                  child: Text(
                    AppTags.login.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile(context) ? 14.sp : 11.sp,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 160.w,
                      child: TabBar(
                        labelColor: Colors.red,
                        unselectedLabelColor: Colors.black,
                        indicatorColor: Colors.red,
                        indicatorSize: TabBarIndicatorSize.label,
                        padding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
                        labelStyle: TextStyle(
                          fontFamily: "Poppins Medium",
                          fontSize: isMobile(context) ? 13.sp : 10.sp,
                        ),
                        tabs: [
                          Tab(text: AppTags.products.tr),
                          Tab(text: AppTags.store.tr),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          FavoriteProduct(favouriteData: controller.data!),
                          FavoriteStore(favouriteData: controller.data!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
