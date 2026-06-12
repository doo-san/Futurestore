import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yoori_ecommerce/src/controllers/currency_converter_controller.dart';
import 'package:yoori_ecommerce/src/controllers/voucher_controller.dart';
import 'package:yoori_ecommerce/src/utils/app_tags.dart';
import 'package:yoori_ecommerce/src/utils/app_theme_data.dart';

import '../../utils/responsive.dart';
import '../../widgets/loader/shimmer_voucher_list.dart';



class VoucherList extends StatefulWidget {
  const VoucherList({super.key});

  @override
  State<VoucherList> createState() => _VoucherListState();
}

class _VoucherListState extends State<VoucherList> {
  final voucherController = Get.put(VoucherController());

  final currencyConverterController = Get.find<CurrencyConverterController>();
  final List fixedColor = const [
    Color(0xFF6DBEA3),
    Color(0xFFFAB75A),
    Color(0xFF4179E0),
    Color(0xFFD16D86),
    Color(0xFF56A8C7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
            AppTags.voucherList.tr,
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
            AppTags.voucherList.tr,
            style: AppThemeData.headerTextStyle_14.copyWith(color: Colors.white),
          ),
        ),
        body: Obx(
          () => voucherController.couponListModel.value!.data != null
              ? voucherController.couponListModel.value!.data!.coupons!.isEmpty ? Center(
            child: Text(
              AppTags.noContent.tr,
              style:  TextStyle(
                fontSize: isMobile(context)? 14.sp:11.sp,
                color: const Color(0xFF666666),
                fontFamily: "Poppins",
              ),
            ),
          ) : ListView.builder(
                  itemCount: voucherController.couponListModel.value!.data!.coupons!.length,
                  itemBuilder: (context, index) {
                    final coupon =
                        voucherController.couponListModel.value!.data!.coupons![index];
                    final Color accent = fixedColor[index % fixedColor.length];
                    final String discountLabel = coupon.discountType == "percent"
                        ? "${coupon.discount.toString()}%"
                        : currencyConverterController
                            .convertCurrency(coupon.discount!.toString());
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 8.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12.r)),
                          border: Border.all(
                              color: accent.withOpacity(0.4), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              // ── Panneau remise (gauche, coloré) ──
                              Container(
                                width: isMobile(context) ? 92.w : 80.w,
                                decoration: BoxDecoration(
                                  color: accent,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.r),
                                    bottomLeft: Radius.circular(12.r),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.w),
                                      child: Text(
                                        discountLabel,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins Medium",
                                          fontWeight: FontWeight.w700,
                                          fontSize:
                                              isMobile(context) ? 20.sp : 14.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.w),
                                      child: Text(
                                        AppTags.off.tr,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontFamily: "Poppins",
                                          fontSize:
                                              isMobile(context) ? 9.sp : 7.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // ── Séparation pointillée ──
                              CustomPaint(
                                size: Size(1.r, double.infinity),
                                painter:
                                    DashedLineVerticalPainter(accent),
                              ),
                              // ── Détails (droite) ──
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(14.r),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        coupon.title ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: const Color(0xFF333333),
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              isMobile(context) ? 14.sp : 10.sp,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time_rounded,
                                              size: 13.r,
                                              color: const Color(0xFF999999)),
                                          SizedBox(width: 5.w),
                                          Expanded(
                                            child: Text(
                                              "${AppTags.validUntil.tr}: ${coupon.endTime.toString()}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: const Color(0xFF666666),
                                                fontFamily: "Poppins",
                                                fontSize: isMobile(context)
                                                    ? 11.sp
                                                    : 8.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      // Code + bouton copier
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 32.h,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w),
                                              decoration: BoxDecoration(
                                                color: accent.withOpacity(0.10),
                                                borderRadius:
                                                    BorderRadius.circular(6.r),
                                                border: Border.all(
                                                    color:
                                                        accent.withOpacity(0.5),
                                                    width: 1),
                                              ),
                                              child: Text(
                                                coupon.code?.toString() ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: accent,
                                                  fontFamily: "Poppins Medium",
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.2,
                                                  fontSize: isMobile(context)
                                                      ? 13.sp
                                                      : 10.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          SizedBox(
                                            height: 32.h,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Clipboard.setData(
                                                  ClipboardData(
                                                      text: coupon.code ?? ''),
                                                ).then(
                                                  (value) =>
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                    SnackBar(
                                                      content: Text(AppTags
                                                          .couponCodeCopied.tr),
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: accent,
                                                elevation: 0,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.w),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6.r),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    AppTags.copy.tr,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "Poppins",
                                                      fontSize: isMobile(context)
                                                          ? 12.sp
                                                          : 9.sp,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Icon(
                                                    Icons.copy,
                                                    color: Colors.white,
                                                    size: isMobile(context)
                                                        ? 13.r
                                                        : 11.r,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const ShimmerVoucherList(),
        ));
  }
}

class DashedLineVerticalPainter extends CustomPainter {
  final Color color;
  DashedLineVerticalPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 5, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
