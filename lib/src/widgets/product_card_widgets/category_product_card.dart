import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ribbon_widget/ribbon_widget.dart';

import '../../controllers/currency_converter_controller.dart';
import '../../controllers/home_screen_controller.dart';
import '../../_route/routes.dart';
import '../../utils/app_theme_data.dart';
import '../../utils/responsive.dart';
import '../../utils/app_tags.dart';
import 'product_cart_control.dart';

class CategoryProductCard extends StatelessWidget {
  final dynamic dataModel;
  final int index;
  /// Overrides the default "NOUVEAU" ribbon label. Pass e.g. 'PROMO'.
  final String? ribbonLabel;

  CategoryProductCard({
    super.key,
    required this.dataModel,
    required this.index,
    this.ribbonLabel,
  });

  final currencyController = Get.find<CurrencyConverterController>();
  final homeController = Get.find<HomeScreenController>();

  static const Color _priceColor = Color(0xFFFE840C);
  static const Color _beigeColor = Color(0xFFF4E6DC);

  @override
  Widget build(BuildContext context) {
    final bool isNew = dataModel?.isNew ?? false;
    final int productId = dataModel?.id ?? 0;
    final String image = dataModel?.image ?? "";
    final String title = dataModel?.title ?? "";
    final String price = (dataModel?.price ?? 0).toString();
    final String discountPrice = (dataModel?.discountPrice ?? 0).toString();
    final String specialDiscount = (dataModel?.specialDiscount ?? 0).toString();
    final String specialDiscountType = dataModel?.specialDiscountType ?? "";
    final int currentStock = dataModel?.currentStock ?? 1;
    final bool hasVariant = dataModel?.hasVariant ?? false;
    final int minOrderQty = dataModel?.minimumOrderQuantity ?? 1;

    final bool hasDiscount = (num.tryParse(specialDiscount) ?? 0) > 0;
    final bool isOutOfStock = currentStock == 0;

    return Ribbon(
      farLength: isNew ? 28 : 0.01,
      nearLength: isNew ? 48 : 0.005,
      title: isNew ? (ribbonLabel ?? AppTags.neW.tr) : "",
      titleStyle: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      color: AppThemeData.productBannerColor,
      location: RibbonLocation.topEnd,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.09),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Get.toNamed(
              Routes.detailsPage,
              parameters: {"productId": productId.toString()},
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── IMAGE ───────────────────────────────────────────
                Expanded(
                  flex: 6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          fit: BoxFit.contain,
                          placeholder: (_, __) => Container(
                            color: const Color(0xFFF5F5F5),
                            child: Center(
                              child: SizedBox(
                                width: 24.r,
                                height: 24.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppThemeData.productBannerColor,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: const Color(0xFFF0F0F0),
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 36.sp,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (hasDiscount)
                        Positioned(
                          top: 8.h,
                          left: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: AppThemeData.productBoxDecorationColor,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              specialDiscountType == 'percentage'
                                  ? "-${homeController.removeTrailingZeros(specialDiscount)}%"
                                  : "-${currencyController.convertCurrency(specialDiscount)}",
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      if (isOutOfStock && !hasDiscount)
                        Positioned(
                          top: 8.h,
                          left: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade600,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              AppTags.stockOut.tr,
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ── BOTTOM BAR ──────────────────────────────────────
                Container(
                  padding: EdgeInsets.fromLTRB(10.w, 8.h, 6.w, 10.h),
                  decoration: BoxDecoration(
                    color: _beigeColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title + price
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: isMobile(context) ? 12.sp : 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                fontFamily: 'Poppins',
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            if (hasDiscount) ...[
                              Text(
                                currencyController.convertCurrency(price),
                                style: TextStyle(
                                  fontSize: isMobile(context) ? 9.sp : 8.sp,
                                  color: Colors.grey.shade600,
                                  fontFamily: 'Poppins',
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                currencyController
                                    .convertCurrency(discountPrice),
                                style: TextStyle(
                                  fontSize: isMobile(context) ? 13.sp : 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: _priceColor,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ] else
                              Text(
                                currencyController.convertCurrency(price),
                                style: TextStyle(
                                  fontSize: isMobile(context) ? 13.sp : 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: _priceColor,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                          ],
                        ),
                      ),

                      SizedBox(width: 6.w),

                      // ── Shared cart control ──────────────────────
                      GestureDetector(
                        onTap: () {}, // absorb tap — prevent card navigation
                        behavior: HitTestBehavior.opaque,
                        child: ProductCartControl(
                          productId: productId,
                          title: title,
                          minOrderQty: minOrderQty,
                          currentStock: currentStock,
                          hasVariant: hasVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
