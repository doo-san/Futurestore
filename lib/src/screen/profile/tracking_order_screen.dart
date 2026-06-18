import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:yoori_ecommerce/src/utils/images.dart';

import '../../controllers/tracking_order_controller.dart';
import '../../models/order_list_model.dart' as ord;
import '../../models/track_order_model.dart';
import 'package:yoori_ecommerce/src/utils/app_tags.dart';
import '../../utils/app_theme_data.dart';
import 'package:yoori_ecommerce/src/utils/responsive.dart';

class TrackingOrder extends StatelessWidget {
  TrackingOrder({super.key});
  final trackingOrderController = Get.find<TrackingOrderController>();

  // Icône dédiée à chaque étape (assets/icons/track_order/*.svg)
  final List<String> _stepIcons = const [
    "order_pending",
    "order_confirm",
    "order_picked",
    "order_on_the_way",
    "order_delivered",
  ];

  // Événements renvoyés par le backend correspondant à chaque étape,
  // utilisés pour retrouver la date à laquelle l'étape a été atteinte.
  final List<List<String>> _stepEvents = const [
    ["order_pending_event", "order_create_event"],
    ["order_confirm_event"],
    ["order_picked_up_event"],
    ["order_on_the_way_event"],
    ["order_delivered_event"],
  ];

  String _stepLabel(int index) {
    switch (index) {
      case 0:
        return AppTags.trkPending.tr;
      case 1:
        return AppTags.trkConfirmed.tr;
      case 2:
        return AppTags.trkPickedUp.tr;
      case 3:
        return AppTags.trkOnTheWay.tr;
      default:
        return AppTags.trkDelivered.tr;
    }
  }

  // Sous-titre = date réelle de l'étape si disponible, sinon son état.
  String _stepSubtitle(int index, Data data) {
    final history = data.order?.orderHistory ?? [];
    final candidates = _stepEvents[index];
    for (final h in history) {
      if (h.event != null &&
          candidates.contains(h.event) &&
          h.createdAt != null) {
        return _formatDate(h.createdAt!);
      }
    }
    final trackStatus = data.order?.orderTrackingStatus ?? 0;
    return index < trackStatus ? AppTags.trkDone.tr : AppTags.trkAwaiting.tr;
  }

  String _formatDate(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormat('dd MMM yyyy, HH:mm').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:isMobile(context)? AppBar(
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
          AppTags.trackOrder.tr,
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
          AppTags.trackOrder.tr,
          style: AppThemeData.headerTextStyle_14.copyWith(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Container(
                height: 48.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppThemeData.boxShadowColor.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: TextField(
                  controller: trackingOrderController.trackingController,
                  cursorColor: Colors.black87,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: AppTags.searchParcel.tr,
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.only(top: 15.h, bottom: 15.h, left: 15.h),
                    hintStyle: TextStyle(
                      fontSize: isMobile(context)? 13.sp:10.sp,
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        if (trackingOrderController
                            .trackingController.text.isNotEmpty) {
                          trackingOrderController.isLoadingUpdate(true);
                          trackingOrderController
                              .getTrackingOrder(trackingOrderController
                              .trackingController.text)
                              .then(
                                (value) {
                              trackingOrderController.isLoadingUpdate(false);
                              trackingOrderController.loadDataUpdate(true);
                            },
                          );
                        } else {
                          trackingOrderController.textFieldEmptySnackBar();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 20.w,
                          top: 15.h,
                          bottom: 15.h,
                          right: 20.w,
                        ),
                        child: SvgPicture.asset(Images.searchBar,
                          height: 17.5.h,
                          width: 18.w,
                        ),
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: isMobile(context)?  15.sp:11.sp,
                  ),
                ),
              ),
            ),
          ),
          Obx(
                () => trackingOrderController.isLoading.value
                ? SizedBox(
              height: 580.h,
              child: Lottie.asset(
                "assets/lottie/searching.json",
                height: 300.h,
                width: 300.w,
              ),
            )
                : trackingOrderController.trackingOrderModel?.data != null
                ? _trackingWidget(context,trackingOrderController.trackingOrderModel!.data!)
            /*Timeline.tileBuilder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        theme: TimelineThemeData(
                          nodePosition: .95,
                          connectorTheme: const ConnectorThemeData(
                            thickness: 3.0,
                            color: Color(0xffd3d3d3),
                            space: 50,
                          ),
                          indicatorTheme: const IndicatorThemeData(
                            size: 15.0,
                          ),
                        ),
                        builder: TimelineTileBuilder.connected(
                          contentsAlign: ContentsAlign.reverse,
                          connectorBuilder: (_, index, _) {
                            if (trackingOrderController.trackingOrderModel!
                                .data!.order!.isOrderDelivered!) {
                              return const DashedLineConnector(
                                color: AppThemeData.dashedLineConnectorColor,
                              );
                            } else {
                              if (index ==
                                  trackingOrderController.trackingOrderModel!
                                          .data!.order!.orderHistory!.length -
                                      2) {
                                return DashedLineConnector(
                                  color: AppThemeData.dashedLineConnectorColor.withOpacity(0.4),
                                );
                              } else {
                                return const DashedLineConnector(
                                  color: AppThemeData.dashedLineConnectorColor,
                                );
                              }
                            }
                          },
                          indicatorBuilder: (_, index) {
                            if (index ==
                                trackingOrderController.trackingOrderModel!
                                        .data!.order!.orderHistory!.length -
                                    1) {
                              return DotIndicator(
                                size: 20.r,
                                color: AppThemeData.dashedLineConnectorColor.withOpacity(0.4),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 15.r,
                                ),
                              );
                            } else {
                              return DotIndicator(
                                size: 20.r,
                                color: AppThemeData.dashedLineConnectorColor,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 15.r,
                                ),
                              );
                            }
                          },
                          itemExtentBuilder: (_, _) => 80.h,
                          contentsBuilder: (context, index) =>
                              orderTrackDetails(
                            trackingOrderController.trackingOrderModel!.data!
                                .order!.orderHistory![trackingOrderController
                                    .trackingOrderModel!
                                    .data!
                                    .order!
                                    .orderHistory!
                                    .length -
                                (index + 1)],
                            index, context,
                          ),
                          itemCount: trackingOrderController.trackingOrderModel!
                              .data!.order!.orderHistory!.length,
                        ),
                      )*/
                : _ordersList(context),
          ),
        ],
      ),
    );
  }

  // Liste des commandes de l'utilisateur sous le champ de recherche.
  // Un tap charge automatiquement la frise de suivi de la commande.
  Widget _ordersList(BuildContext context) {
    if (trackingOrderController.ordersLoading.value) {
      return SizedBox(
        height: 300.h,
        child: Center(
          child: CircularProgressIndicator(
            color: AppThemeData.trackingSelectorColor,
          ),
        ),
      );
    }
    final orders = trackingOrderController.orderListModel.data?.orders ?? [];
    if (orders.isEmpty) {
      return SizedBox(
        height: 580.h,
        child: Center(
          child: Lottie.asset(
            "assets/lottie/notFound.json",
            height: 300.h,
            width: 300.w,
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.h, left: 2.w),
            child: Text(
              AppTags.trkSelectOrder.tr,
              style: TextStyle(
                fontFamily: "Poppins Medium",
                fontWeight: FontWeight.w600,
                fontSize: isMobile(context) ? 14.sp : 11.sp,
                color: const Color(0xff333333),
              ),
            ),
          ),
          ...orders.map((o) => _orderCard(context, o)),
        ],
      ),
    );
  }

  Widget _orderCard(BuildContext context, ord.Orders o) {
    final code = o.orderCode?.toString() ?? '';
    final isPaid = (o.paymentStatus ?? '').toLowerCase() == 'paid';
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: () {
          if (code.isEmpty) return;
          trackingOrderController.trackingController.text = code;
          trackingOrderController.isLoadingUpdate(true);
          trackingOrderController.getTrackingOrder(code).then((value) {
            trackingOrderController.isLoadingUpdate(false);
            trackingOrderController.loadDataUpdate(true);
          });
        },
        child: Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: AppThemeData.boxShadowColor.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "#$code",
                      style: TextStyle(
                        fontFamily: "Poppins Medium",
                        fontWeight: FontWeight.w700,
                        fontSize: isMobile(context) ? 14.sp : 11.sp,
                        color: const Color(0xff333333),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      o.date?.toString() ?? '',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: isMobile(context) ? 12.sp : 9.sp,
                        color: const Color(0xff777777),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: (isPaid
                          ? const Color(0xff2E9E7B)
                          : const Color(0xffFF0008))
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  isPaid ? AppTags.paid.tr : AppTags.unpaid.tr,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: isMobile(context) ? 11.sp : 8.sp,
                    color: isPaid
                        ? const Color(0xff2E9E7B)
                        : const Color(0xffFF0008),
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Icon(Icons.chevron_right,
                  size: 20.r, color: const Color(0xffBBBBBB)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _trackingWidget(context,Data data)=>Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: 343.w,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow:  const [
          BoxShadow(
              color: Color(0x0D404040),
              offset: Offset(0, 1),
              spreadRadius: 0.5,
              blurRadius: 1),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(10.r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0,top: 16.0),
            child: Text(AppTags.trkInfoTitle.tr,style: (Theme.of(context).textTheme.displayLarge ?? const TextStyle()).copyWith(fontWeight: FontWeight.w600,fontSize: 16.sp),),
          ),
          Timeline.tileBuilder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            theme: TimelineThemeData(
              nodePosition: .95,
              connectorTheme: const ConnectorThemeData(
                thickness: 2.0,
                color: Color(0xffd3d3d3),
              ),
              indicatorTheme: const IndicatorThemeData(
                size: 15.0,
              ),
            ),
            builder: TimelineTileBuilder.connected(
              contentsAlign: ContentsAlign.reverse,
              connectorBuilder: (_, index, _) {
                final trackStatus = data.order?.orderTrackingStatus ?? 0;
                return DashedLineConnector(
                  color: index < trackStatus ? AppThemeData.trackingSelectorColor : AppThemeData.trackingUnSelectorColor,
                  gap: 3,
                );
              },
              itemExtentBuilder: (_, _) => 70.h,
              contentsBuilder: (context, index) =>
                  orderTrackDetails(index, context, data),

              itemCount: 5,
              indicatorBuilder: (_, index) {
                final trackStatus = data.order?.orderTrackingStatus ?? 0;
                return  DotIndicator(
                  size: 20.r,
                  color: index < trackStatus ? AppThemeData.trackingSelectorColor : AppThemeData.trackingUnSelectorColor,
                  child: Icon(
                    Icons.check,
                    color: index < trackStatus ? Colors.white : Colors.transparent,
                    size: 15.r,
                  ),
                );
              },

            ),
          ),
        ],
      ),
    ),
  );
  Widget? orderTrackDetails(int index, BuildContext context, Data data) {
    return deliveryTrackItem(
        _stepIcons[index],
        _stepLabel(index),
        _stepSubtitle(index, data),
        index,
        context
    );
  }

  /* Widget? orderTrackDetails(OrderHistory orderHistory, index,context) {
    switch (orderHistory.event) {
      case "order_create_event":
        return deliveryTrackItem(
          "order_created",
          "Order Created",
          orderHistory.createdAt,
          index,
            context
        );
      case "delivery_hero_assigned":
        return deliveryTrackItem(
          "delivery_hero_assigned",
          "Delivery Hero Assigned",
          orderHistory.createdAt,
          index,
            context
        );
      case "delivery_hero_changed":
        return deliveryTrackItem(
          "delivery_hero_changed",
          "Delivery Hero Changed",
          orderHistory.createdAt,
          index,
            context
        );
      case "order_confirm_event":
        return deliveryTrackItem(
          "order_confirm",
          "Order Confirm",
          orderHistory.createdAt,
          index,
            context
        );
      case "order_picked_up_event":
        return deliveryTrackItem(
          "order_picked",
          "Order Picked Up",
          orderHistory.createdAt,
          index,
            context
        );
      case "order_on_the_way_event":
        return deliveryTrackItem(
          "order_on_the_way",
          "Order On The way",
          orderHistory.createdAt,
          index,
            context
        );
      case "order_pending_event":
        return deliveryTrackItem(
          "order_pending",
          "Order Pending",
          orderHistory.createdAt,
          index,
            context
        );
      case "order_canceled_event":
        return deliveryTrackItem(
          "order_cancelled",
          "Order Cancelled",
          orderHistory.createdAt,
          index,
            context
        );
      case "order_delivered_event":
        return deliveryTrackItem(
          "order_delivered",
          "Order Delivered",
          orderHistory.createdAt,
          index,
            context
        );
      case "pending":
        return deliveryTrackItem(
          "order_delivered",
          "Order Delivered",
          "Pending",
          index,
            context
        );
      default:
        return deliveryTrackItem(
          "",
          "",
          "",
          index,
          context,
        );
    }
  }*/

  Widget deliveryTrackItem(image, title, subtitle, index,context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 42.w,
          height: 42.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            color: AppThemeData.trackingMultipleColor[index % AppThemeData.trackingMultipleColor.length].withOpacity(0.1),
          ),
          child: Center(
            child: SvgPicture.asset(
              "assets/icons/track_order/$image.svg",
              height: 21.h,
              width: 21.w,
              color: AppThemeData.trackingMultipleColor[index % AppThemeData.trackingMultipleColor.length],
            ),
          ),
        ),
        title: Text(
          title,
          style: isMobile(context)? AppThemeData.trackingOrderTitle:AppThemeData.trackingOrderTitleTab,
        ),
        subtitle: Text(
          subtitle,
          style: isMobile(context)? AppThemeData.trackingOrderSubTitle:AppThemeData.trackingOrderSubTitleTab,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

