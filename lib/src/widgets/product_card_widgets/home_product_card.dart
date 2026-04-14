import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ribbon_widget/ribbon_widget.dart';
import 'package:yoori_ecommerce/src/controllers/details_screen_controller.dart';
import '../../_route/routes.dart';
import '../../controllers/currency_converter_controller.dart';
import '../../controllers/home_screen_controller.dart';
import 'package:yoori_ecommerce/src/utils/app_tags.dart';
import '../../utils/app_theme_data.dart';
import 'package:yoori_ecommerce/src/utils/responsive.dart';
import 'product_cart_control.dart';

class HomeProductCard extends StatelessWidget {
  HomeProductCard({
    super.key,
    required this.dataModel,
    required this.index,
  });
  final dynamic dataModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final homeScreenContentController = Get.find<HomeScreenController>();

    return InkWell(
      onTap: (){
        Get.toNamed(
          Routes.detailsPage,
          parameters: {
            'productId': dataModel[index].id!.toString(),
          },
        );
         Get.find<DetailsPageController>().isFavoriteLocal.value = dataModel[index].isFavourite;
      },

      child: Ribbon(
        farLength: (dataModel?[index].isNew ?? false) ? (isMobile(context) ? 20.0 : 40.0) : 0.01,
        nearLength: (dataModel?[index].isNew ?? false) ? (isMobile(context) ? 40.0 : 80.0) : 0.005,
        title: dataModel?[index].isNew ?? false ? AppTags.neW.tr : '',
        titleStyle: TextStyle(
          fontSize: isMobile(context)?10.sp:7.sp,
          color: dataModel?[index].isNew ?? false ? Colors.white : Colors.transparent,
          fontFamily: 'Poppins',
        ),
        color: dataModel?[index].isNew ?? false ? AppThemeData.productBannerColor : Colors.transparent,
        location: RibbonLocation.topEnd,
        child: Container(
          width:isMobile(context)? 165.w:120.w,
          height: 230.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(7.r),
            ),
            boxShadow: [
              BoxShadow(
                color: AppThemeData.boxShadowColor.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 20.r,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child:  Stack(
            children: [
              GetBuilder<CurrencyConverterController>(
                builder: (currencyConverterController){
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0.r),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(child: Row(
                              children: [
                                dataModel![index].specialDiscountType == 'flat'
                                    ? (num.tryParse((dataModel![index].specialDiscount?.toString() ?? '').replaceAll(',', '')) ?? 0) ==
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
                                      "${currencyConverterController.convertCurrency(dataModel![index].specialDiscount!)} OFF",
                                      style:isMobile(context)? AppThemeData.todayDealNewStyle:AppThemeData.todayDealNewStyleTab,
                                    ),
                                  ),
                                )
                                    : dataModel![index].specialDiscountType ==
                                    'percentage'
                                    ? (num.tryParse((dataModel![index].specialDiscount?.toString() ?? '').replaceAll(',', '')) ?? 0) ==
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
                                      "${homeScreenContentController.removeTrailingZeros(dataModel![index].specialDiscount)}% OFF",
                                      textAlign: TextAlign.center,
                                      style:isMobile(context)? AppThemeData.todayDealNewStyle:AppThemeData.todayDealNewStyleTab,
                                    ),
                                  ),
                                )
                                    : Container(),
                                dataModel![index].specialDiscount == 0
                                    ? const SizedBox()
                                    : SizedBox(width: 5.w),
                                dataModel![index].currentStock == 0
                                    ? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                                  decoration: BoxDecoration(
                                    color: AppThemeData.productBoxDecorationColor.withOpacity(0.06),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(3.r)),
                                  ),
                                  child: Text(
                                    AppTags.stockOut.tr,
                                    style: isMobile(context)? AppThemeData.todayDealNewStyle:AppThemeData.todayDealNewStyleTab,
                                  ),
                                )
                                    : const SizedBox(),
                              ],
                            )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0.r),
                          child: CachedNetworkImage(
                            imageUrl: dataModel![index].image ?? "",
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
                      dataModel![index].reward == 0
                          ? SizedBox(height: 14.h)
                          : Container(
                        width: double.infinity,
                        color: Colors.yellow.withOpacity(0.3),
                        padding: EdgeInsets.all(2.r),
                        child: Center(
                          child: Text(
                            "${AppTags.reward.tr}: ${dataModel![index].reward}",
                            style: AppThemeData.rewardStyle,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: Text(dataModel![index].title!,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: isMobile(context)? AppThemeData.todayDealTitleStyle:AppThemeData.todayDealTitleStyleTab),
                      ),
                      SizedBox(height: 5.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: isMobile(context)? 18.w:10.w),
                        child: Center(
                          child: (num.tryParse((dataModel![index].specialDiscount?.toString() ?? '').replaceAll(',', '')) ?? 0) == 0.0
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    currencyConverterController
                                        .convertCurrency(dataModel![index].price!),
                                    style: isMobile(context)? AppThemeData.todayDealDiscountPriceStyle:AppThemeData.todayDealDiscountPriceStyleTab,
                                  ),
                                ],
                              ) : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  currencyConverterController.convertCurrency(
                                    dataModel![index].price!,
                                  ),
                                  style: isMobile(context)? AppThemeData.todayDealOriginalPriceStyle:AppThemeData.todayDealOriginalPriceStyleTab,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(width: isMobile(context)? 8.w:4.w),
                              Flexible(
                                child: Text(
                                  currencyConverterController.convertCurrency(
                                      dataModel![index].discountPrice!),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: isMobile(context)? AppThemeData.todayDealDiscountPriceStyle:AppThemeData.todayDealDiscountPriceStyleTab,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                    ],
                  );
                },
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
