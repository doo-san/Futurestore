import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ribbon_widget/ribbon_widget.dart';
import 'package:flutter/material.dart';
import 'package:yoori_ecommerce/src/controllers/details_screen_controller.dart';
import '../../_route/routes.dart';
import '../../controllers/currency_converter_controller.dart';
import '../../controllers/home_screen_controller.dart';
import 'package:yoori_ecommerce/src/utils/app_tags.dart';
import '../../utils/app_theme_data.dart';
import 'package:yoori_ecommerce/src/utils/responsive.dart';
import 'product_cart_control.dart';

class ShopProductCard extends StatelessWidget {
  ShopProductCard({
    super.key,
    required this.dataModel,
    required this.index,
  });
  final dynamic dataModel;
  final int index;
  final currencyConverterController = Get.find<CurrencyConverterController>();

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeScreenController());
    return Ribbon(
      farLength: (dataModel[index].isNew ?? false) ? isMobile(context)?20:30 : 0.01,
      nearLength: (dataModel[index].isNew ?? false) ?  isMobile(context)?40:50 : 0.005,
      title: (dataModel[index].isNew ?? false) ?AppTags.neW.tr:"",
      titleStyle:  TextStyle(
        fontSize:  isMobile(context)?10.sp:7.sp,
        fontFamily: 'Poppins',
      ),
      color: AppThemeData.productBannerColor,
      location: RibbonLocation.topEnd,
      child: Container(
        height: 230.h,
        width:  isMobile(context)? 165.w:125.w,
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
                'productId': dataModel[index]
                    .id!
                    .toString(),
              },
            );
            Get.find<DetailsPageController>().isFavoriteLocal.value = dataModel[index].isFavourite ?? false;
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
                            dataModel[index].specialDiscountType == 'flat'
                                ? (num.tryParse(dataModel[index].specialDiscount?.toString() ?? '0') ?? 0) ==
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
                                            "${currencyConverterController.convertCurrency(dataModel[index].specialDiscount)} OFF",
                                            style: isMobile(context)?AppThemeData.todayDealNewStyle:AppThemeData.todayDealNewStyleTab,
                                          ),
                                        ),
                                      )
                                : dataModel[index].specialDiscountType ==
                                        'percentage'
                                    ? (num.tryParse(dataModel[index].specialDiscount?.toString() ?? '0') ?? 0) ==
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
                                                "${homeController.removeTrailingZeros(dataModel[index].specialDiscount)}% OFF",
                                                textAlign: TextAlign.center,
                                                style:
                                                isMobile(context)?AppThemeData.todayDealNewStyle:AppThemeData.todayDealNewStyleTab,
                                              ),
                                            ),
                                          )
                                    : Container(),
                          ],
                        ),
                        (num.tryParse(dataModel[index].specialDiscount?.toString() ?? '0') ?? 0) == 0.0
                            ? const SizedBox()
                            : SizedBox(width: 5.w),
                        dataModel[index].currentStock == 0
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: AppThemeData.productBoxDecorationColor.withOpacity(0.06),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.r)),
                                ),
                                child: Text(
                                  AppTags.stockOut.tr,
                                  style: isMobile(context)?AppThemeData.todayDealNewStyle:AppThemeData.todayDealNewStyleTab,
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
                      child: CachedNetworkImage(
                        imageUrl: dataModel[index].image ?? "",
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 1.5),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey.shade100,
                          child: Image.asset(
                            'assets/logos/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7.w),
                    child: Text(
                      dataModel[index].title!,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: isMobile(context)?AppThemeData.todayDealTitleStyle:AppThemeData.todayDealTitleStyleTab,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Padding(
                     padding: EdgeInsets.symmetric(horizontal: 7.w),
                    child: Center(
                      child: (num.tryParse(dataModel[index].specialDiscount?.toString() ?? '0') ?? 0) == 0.0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currencyConverterController
                                      .convertCurrency((dataModel[index].price ?? '0')),
                                  style: isMobile(context)? AppThemeData.todayDealDiscountPriceStyle: AppThemeData.todayDealDiscountPriceStyleTab,
                                ),
                              ],
                            )
                          : Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currencyConverterController
                                      .convertCurrency((dataModel[index].price ?? '0')),
                                  style:isMobile(context)? AppThemeData.todayDealOriginalPriceStyle:AppThemeData.todayDealOriginalPriceStyleTab,
                                ),
                                SizedBox(width: 5.w,),
                                Text(
                                  currencyConverterController.convertCurrency(
                                      (dataModel[index].discountPrice ?? '0')),
                                  style: isMobile(context)? AppThemeData.todayDealDiscountPriceStyle: AppThemeData.todayDealDiscountPriceStyleTab,
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
                    productId: dataModel![index].id ?? 0,
                    title: dataModel![index].title ?? '',
                    minOrderQty: dataModel![index].minimumOrderQuantity ?? 1,
                    currentStock: dataModel![index].currentStock ?? 0,
                    hasVariant: dataModel![index].hasVariant ?? false,
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
