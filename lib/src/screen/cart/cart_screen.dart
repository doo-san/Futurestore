import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../_route/routes.dart';
import '../../controllers/cart_content_controller.dart';
import '../../controllers/currency_converter_controller.dart';
import '../../data/local_data_helper.dart';
import 'package:yoori_ecommerce/src/utils/app_tags.dart';
import '../../utils/app_theme_data.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/cart_item.dart';
import '../../models/add_to_cart_list_model.dart';
import 'package:yoori_ecommerce/src/utils/responsive.dart';
import '../../widgets/loader/shimmer_cart_content.dart';
import 'check_out_screen.dart';
import 'empty_cart_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final TextEditingController couponController =
  TextEditingController();

  late CartContentController _cartController =
  Get.put(CartContentController());

  final currencyConverterController =
  Get.find<CurrencyConverterController>();

  @override
  void initState() {
    super.initState();

      _cartController = Get.put(CartContentController());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_cartController.isLoading) {
        return const ShimmerCartContent();
      }

      final model = _cartController.addToCartListModel;

      // 🔐 PROTECTION TOTALE
      if (model.data == null ||
          model.data?.carts == null ||
          (model.data?.carts ?? []).isEmpty) {
        return EmptyCartScreen();
      }

      return _mainUi(model, context);
    });
  }

  Widget _mainUi(AddToCartListModel model, BuildContext context) {
    final carts = model.data?.carts ?? [];
    final calculations = model.data?.calculations;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeData.productBoxDecorationColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppTags.myCart.tr,
          style: isMobile(context)
              ? AppThemeData.headerTextStyle_16.copyWith(color: Colors.white)
              : AppThemeData.headerTextStyle_14.copyWith(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: carts.length,
              itemBuilder: (context, index) {
                return CartItem(
                  cart: carts[index], cartList: null,
                );
              },
            )
          ),

          // Section coupon
          Obx(() {
            final appliedCoupons = _cartController.appliedCouponList.data ?? [];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Coupons appliqués
                  if (appliedCoupons.isNotEmpty) ...[
                    ...appliedCoupons.map((coupon) => Container(
                      margin: EdgeInsets.only(bottom: 6.h),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: const Color(0xFF4CAF50), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.local_offer, color: const Color(0xFF4CAF50), size: 16.r),
                              SizedBox(width: 6.w),
                              Text(
                                coupon.title ?? '',
                                style: TextStyle(
                                  color: const Color(0xFF2E7D32),
                                  fontSize: isMobile(context) ? 13.sp : 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => _cartController.removeCoupon(
                              couponId: coupon.couponId ?? 0,
                            ),
                            child: Icon(Icons.close, color: Colors.red.shade400, size: 18.r),
                          ),
                        ],
                      ),
                    )),
                    SizedBox(height: 4.h),
                  ],
                  // Champ de saisie coupon
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: couponController,
                          style: TextStyle(fontSize: isMobile(context) ? 13.sp : 10.sp),
                          decoration: InputDecoration(
                            hintText: AppTags.couponApply.tr,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: isMobile(context) ? 13.sp : 10.sp,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 10.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppThemeData.productBoxDecorationColor,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Obx(() => _cartController.isAplyingCoupon
                          ? SizedBox(
                              width: 44.w,
                              height: 44.h,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppThemeData.productBoxDecorationColor,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 12.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: () {
                                final code = couponController.text.trim();
                                if (code.isNotEmpty) {
                                  _cartController.applyCouponCode(code: code);
                                  couponController.clear();
                                }
                              },
                              child: Text(
                                AppTags.apply.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile(context) ? 13.sp : 10.sp,
                                ),
                              ),
                            )),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            );
          }),

          // 🔐 CALCULATION CARD (SAFE)
          Padding(
            padding: EdgeInsets.only(
                right: 15.w, left: 15.w, bottom: 15.h),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.all(Radius.circular(10.r)),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 30,
                    blurRadius: 5,
                    color: AppThemeData.boxShadowColor
                        .withOpacity(0.01),
                    offset: const Offset(0, 15),
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Column(
                  children: [
                    _priceRow(
                      AppTags.subTotal.tr,
                      currencyConverterController
                          .convertCurrency(
                          calculations?.formattedSubTotal ??
                              "0"),
                      context,
                    ),
                    _priceRow(
                      AppTags.discount.tr,
                      currencyConverterController
                          .convertCurrency(
                          calculations?.formattedDiscount ??
                              "0"),
                      context,
                    ),
                    _priceRow(
                      AppTags.deliveryCharge.tr,
                      currencyConverterController
                          .convertCurrency(
                          calculations
                              ?.formattedShippingCost ??
                              "0"),
                      context,
                    ),
                    _priceRow(
                      AppTags.tax.tr,
                      currencyConverterController
                          .convertCurrency(
                          calculations?.formattedTax ??
                              "0"),
                      context,
                    ),
                    if ((calculations?.formattedCouponDiscount ?? "0") != "0")
                      _couponDiscountRow(
                        AppTags.coupon.tr,
                        currencyConverterController.convertCurrency(
                          calculations?.formattedCouponDiscount ?? "0",
                        ),
                        context,
                      ),
                    const Divider(),
                    _priceRow(
                      AppTags.total.tr,
                      currencyConverterController
                          .convertCurrency(
                          calculations?.formattedTotal ??
                              "0"),
                      context,
                    ),
                    SizedBox(height: 10.h),
                    InkWell(
                      onTap: () {
                        final disableGuest = LocalDataHelper()
                                .getConfigData()
                                .data
                                ?.appConfig
                                ?.disableGuest ??
                            false;
                        if (disableGuest &&
                            LocalDataHelper().getUserToken() == null) {
                          Get.toNamed(Routes.logIn);
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CheckOutScreen(
                                    addToCartListModel: model,
                                  ),
                            ),
                          );
                        }
                      },
                      child: ButtonWidget(
                          buttonTittle:
                          AppTags.checkOut.tr),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _priceRow(
      String title, String value, BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isMobile(context)
              ? AppThemeData.titleTextStyle_14
              : AppThemeData.titleTextStyle_11Tab,
        ),
        Text(
          value,
          style: isMobile(context)
              ? AppThemeData.titleTextStyle_14
              : AppThemeData.titleTextStyle_11Tab,
        ),
      ],
    );
  }

  Widget _couponDiscountRow(
      String title, String value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.local_offer, color: const Color(0xFF4CAF50), size: 14.r),
            SizedBox(width: 4.w),
            Text(
              title,
              style: (isMobile(context)
                  ? AppThemeData.titleTextStyle_14
                  : AppThemeData.titleTextStyle_11Tab)
                  .copyWith(color: const Color(0xFF2E7D32)),
            ),
          ],
        ),
        Text(
          '- $value',
          style: (isMobile(context)
              ? AppThemeData.titleTextStyle_14
              : AppThemeData.titleTextStyle_11Tab)
              .copyWith(color: const Color(0xFF2E7D32)),
        ),
      ],
    );
  }
}