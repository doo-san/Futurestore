import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ribbon_widget/ribbon_widget.dart';
import '../../_route/routes.dart';
import '../../controllers/currency_converter_controller.dart';
import '../../controllers/home_screen_controller.dart';
import '../../models/search_product_model.dart';
import 'package:yoori_ecommerce/src/utils/app_tags.dart';
import '../../utils/app_theme_data.dart';
import 'package:yoori_ecommerce/src/utils/responsive.dart';
import 'package:yoori_ecommerce/src/widgets/network_image_checker.dart';
import 'product_cart_control.dart';

class SearchProductCard extends StatelessWidget {
  SearchProductCard({required this.data, super.key});
  late final SearchProductData data;
  final currencyConverterController = Get.find<CurrencyConverterController>();
  final homeController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Ribbon(
      farLength: (data.isNew ?? false) ? 20 : 0.01,
      nearLength: (data.isNew ?? false) ? 40 : 0.005,
      title: (data.isNew ?? false) ? AppTags.neW.tr : "",
      titleStyle: AppThemeData.timeDateTextStyle_11.copyWith(fontSize: 10.sp),
      color: AppThemeData.productBannerColor,
      location: RibbonLocation.topEnd,
      child: Container(
        height: 230.h,
        width: 165.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(7.r)),
          boxShadow: [
            BoxShadow(
              color: AppThemeData.boxShadowColor.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 20.r,
              offset: const Offset(0, 10), 
            ),
          ],
        ),
        child: InkWell(
          onTap: () {

            Get.toNamed(
              Routes.detailsPage,
              parameters: {
                'productId': data.id!.toString(),
              },
            );
          },
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            data.specialDiscountType == 'flat'
                                ? (num.tryParse((data.specialDiscount ?? '').replaceAll(',', '')) ?? 0) == 0.0
                                    ? const SizedBox()
                                    : Container(
                                        height: 20.h,
                                        decoration: BoxDecoration(
                                          color: AppThemeData.productBoxDecorationColor
                                              .withOpacity(0.06),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(3.r),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${currencyConverterController.convertCurrency(data.specialDiscount)} OFF",
                                            style: isMobile(context)? AppThemeData.todayDealNewStyle:AppThemeData.todayDealNewStyleTab,
                                          ),
                                        ),
                                      )
                                : data.specialDiscountType == 'percentage'
                                    ? num.parse(data.specialDiscount ?? "0") ==
                                            0.0
                                        ? const SizedBox()
                                        : Container(
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              color: AppThemeData.productBoxDecorationColor
                                                  .withOpacity(0.06),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(3.r),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${homeController.removeTrailingZeros(data.specialDiscount ?? "0")}% OFF",
                                                textAlign: TextAlign.center,
                                                style:
                                                isMobile(context)? AppThemeData.todayDealNewStyle:AppThemeData.todayDealNewStyleTab,
                                              ),
                                            ),
                                          )
                                    : Container(),
                          ],
                        ),
                        data.specialDiscount == null
                            ? const SizedBox()
                            : SizedBox(width: 5.w),
                        data.currentStock == 0
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: AppThemeData.productBoxDecorationColor.withOpacity(0.06),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.r)),
                                ),
                                child: Text(
                                  AppTags.stockOut.tr,
                                  style:  isMobile(context)? AppThemeData.todayDealNewStyle:AppThemeData.todayDealNewStyleTab,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: NetworkImageCheckerWidget(
                        image: data.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7.w),
                    child: Text(
                      data.title!,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: isMobile(context)? AppThemeData.todayDealTitleStyle:AppThemeData.todayDealTitleStyleTab,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile(context)?18.w:10.w),
                    child: Center(
                      child: (num.tryParse((data.specialDiscount ?? '').replaceAll(',', '')) ?? 0) == 0.0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currencyConverterController
                                      .convertCurrency(data.price!),
                                  style: isMobile(context)? AppThemeData.todayDealDiscountPriceStyle:AppThemeData.todayDealDiscountPriceStyleTab,
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currencyConverterController
                                      .convertCurrency(data.price!),
                                  style: AppThemeData.todayDealOriginalPriceStyle,
                                ),
                                SizedBox(width:isMobile(context)? 15.w:5.w),
                                Text(
                                  currencyConverterController
                                      .convertCurrency(data.discountPrice!),
                                  style: isMobile(context)? AppThemeData.todayDealDiscountPriceStyle:AppThemeData.todayDealDiscountPriceStyleTab,
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                ],
              ),
              Positioned(
                bottom: isMobile(context) ? 50.h : 52.h,
                right: 8,
                child: GestureDetector(
                  onTap: () {},
                  behavior: HitTestBehavior.opaque,
                  child: ProductCartControl(
                    productId: data.id ?? 0,
                    title: data.title ?? '',
                    minOrderQty: data.minimumOrderQuantity ?? 1,
                    currentStock: data.currentStock ?? 0,
                    hasVariant: data.hasVariant ?? false,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
