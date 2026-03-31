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
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppTags.myCart.tr,
          style: isMobile(context)
              ? AppThemeData.headerTextStyle_16
              : AppThemeData.headerTextStyle_14,
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
                        if (LocalDataHelper()
                            .getConfigData()
                            .data!
                            .appConfig!
                            .disableGuest! &&
                            LocalDataHelper()
                                .getUserToken() ==
                                null) {
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
}