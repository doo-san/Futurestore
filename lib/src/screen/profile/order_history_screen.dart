import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../_route/routes.dart';
import '../../controllers/currency_converter_controller.dart';
import '../../controllers/order_history_controller.dart';
import '../../data/local_data_helper.dart';
import 'package:yoori_ecommerce/src/utils/app_tags.dart';
import '../../utils/app_theme_data.dart';
import 'package:yoori_ecommerce/src/utils/responsive.dart';
import '../../widgets/loader/shimmer_order_history.dart';


enum RouteCheckOfOrderHistory {
  profileScreen,
  paymentCompleteScreen,
}

class OrderHistory extends StatelessWidget {
  OrderHistory({super.key});
  final String routeName = Get.parameters['routeName']!;
  final currencyConverterController = Get.find<CurrencyConverterController>();
  final orderHistoryController = Get.find<OrderHistoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context)? AppBar(
        backgroundColor: const Color(0xFFFF0008),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            if (routeName ==
                RouteCheckOfOrderHistory.profileScreen.toString()) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.dashboardScreen);
            }
          },
        ),
        centerTitle: true,
        title: Text(
          AppTags.orderHistory.tr,
          style: AppThemeData.headerTextStyle_16.copyWith(color: Colors.white),
        ),
      ): AppBar(
        backgroundColor: const Color(0xFFFF0008),
        elevation: 0,
        toolbarHeight: 60.h,
        leadingWidth: 40.w,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 25.r,
          ),

          onPressed: () {
            Get.back();
          }, 
        ),
        centerTitle: true,
        title: Text(
          AppTags.orderHistory.tr,
          style: AppThemeData.headerTextStyle_14.copyWith(color: Colors.white),
        ),
      ),
      body: Obx(
        () => orderHistoryController.isLoading.value
            ? const ShimmerOrderHistory()
            : orderHistoryController.orderListModel.data!.orders!.isNotEmpty? ListView.builder(
                shrinkWrap: true,
                itemCount:
                    orderHistoryController.orderListModel.data!.orders!.length,
                itemBuilder: (context, index) {
                  String orderStatus = orderHistoryController.orderListModel.data!.orders![index].paymentStatus.toString();
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15.w, vertical: 8.h),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.invoiceScreen, parameters: {
                          'trackingId': orderHistoryController
                              .orderListModel.data!.orders![index].orderCode
                              .toString(),
                        },);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppThemeData.orderHistoryMainBoxColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.r),
                          ),
                          border: Border.all(
                              color: const Color(0xffEDEDED), width: 1),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 0,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.05),
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // En-tête : n° de facture + badge statut
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "${AppTags.invoice.tr} #",
                                          style: (isMobile(context)
                                                  ? AppThemeData
                                                      .orderHistoryTextStyle_12
                                                  : AppThemeData
                                                      .orderHistoryTextStyle_9Tab)
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        Flexible(
                                          child: SelectableText(
                                            orderHistoryController.orderListModel
                                                .data!.orders![index].orderCode
                                                .toString(),
                                            maxLines: 1,
                                            style: (isMobile(context)
                                                    ? AppThemeData
                                                        .orderHistoryTextStyle_12
                                                    : AppThemeData
                                                        .orderHistoryTextStyle_9Tab)
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: (orderStatus == "unpaid"
                                              ? const Color(0xffFF0008)
                                              : const Color(0xff2E9E7B))
                                          .withOpacity(0.12),
                                      borderRadius:
                                          BorderRadius.circular(20.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          orderStatus == "unpaid"
                                              ? Icons.cancel
                                              : Icons.check_circle,
                                          size: 13.r,
                                          color: orderStatus == "unpaid"
                                              ? const Color(0xffFF0008)
                                              : const Color(0xff2E9E7B),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          orderStatus == "unpaid"
                                              ? AppTags.unpaid.tr
                                              : AppTags.paid.tr,
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize:
                                                isMobile(context) ? 11.sp : 9.sp,
                                            fontWeight: FontWeight.w600,
                                            color: orderStatus == "unpaid"
                                                ? const Color(0xffFF0008)
                                                : const Color(0xff2E9E7B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: const Color(0xffF0F0F0)),
                              SizedBox(height: 12.h),
                              // Date de commande
                              Row(
                                children: [
                                  Icon(Icons.calendar_today_outlined,
                                      size: 14.r,
                                      color: const Color(0xff999999)),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      "${AppTags.orderDate.tr}: ${orderHistoryController.orderListModel.data!.orders![index].date.toString()}",
                                      style: isMobile(context)
                                          ? AppThemeData.orderHistoryTextStyle_12
                                          : AppThemeData
                                              .orderHistoryTextStyle_9Tab,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              // Montant
                              Row(
                                children: [
                                  Icon(Icons.payments_outlined,
                                      size: 14.r,
                                      color: const Color(0xff999999)),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "${AppTags.amount.tr}: ",
                                    style: isMobile(context)
                                        ? AppThemeData.orderHistoryTextStyle_12
                                        : AppThemeData
                                            .orderHistoryTextStyle_9Tab,
                                  ),
                                  Text(
                                    currencyConverterController.convertCurrency(
                                        orderHistoryController
                                            .orderListModel
                                            .data!
                                            .orders![index]
                                            .totalPayable
                                            .toString()),
                                    style: (isMobile(context)
                                            ? AppThemeData
                                                .orderHistoryTextStyle_12
                                            : AppThemeData
                                                .orderHistoryTextStyle_9Tab)
                                        .copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xffFF0008)),
                                  ),
                                ],
                              ),
                              // Bouton Payer (commandes impayées uniquement)
                              if (orderStatus == "unpaid") ...[
                                SizedBox(height: 14.h),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(
                                      Routes.paymentScreen,
                                      parameters: {
                                        'trxId': LocalDataHelper()
                                                .getCartTrxId() ??
                                            "",
                                        'token': LocalDataHelper()
                                                .getUserToken() ??
                                            ""
                                      },
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: 38.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFF0008),
                                      borderRadius:
                                          BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      AppTags.payNow.tr,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize:
                                            isMobile(context) ? 13.sp : 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ) : Center(
              child: Text(AppTags.emptyOrderHistory.tr),
        ),
      ),
    );
  }
}
