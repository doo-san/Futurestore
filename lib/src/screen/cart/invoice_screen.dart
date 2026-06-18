import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../controllers/currency_converter_controller.dart';
import '../../controllers/invoice_screen_controller.dart';
import '../../models/track_order_model.dart';
import '../../utils/app_theme_data.dart';
import '../../utils/invoice_pdf_generator.dart';
import 'package:yoori_ecommerce/src/utils/app_tags.dart';
import 'package:yoori_ecommerce/src/utils/responsive.dart';
import '../../widgets/loader/shimmer_invoice.dart';

class InvoiceScreen extends StatelessWidget {
  InvoiceScreen({super.key});
  final trackingId = Get.parameters['trackingId'];

  final currencyConverterController = Get.find<CurrencyConverterController>();
  final InvoiceScreenController invoiceScreenController =
      Get.put(InvoiceScreenController());

  static const Color _dark = Color(0xFF333333);
  static const Color _grey = Color(0xFF777777);
  static const Color _brand = Color(0xFFFF0008);
  static const Color _green = Color(0xFF2E9E7B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: isMobile(context)
          ? AppBar(
              backgroundColor: _brand,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              centerTitle: true,
              title: Text(
                trackingId.toString(),
                style: AppThemeData.headerTextStyle_16
                    .copyWith(color: Colors.white),
              ),
            )
          : AppBar(
              backgroundColor: _brand,
              elevation: 0,
              toolbarHeight: 60.h,
              leadingWidth: 40.w,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 25.r),
                onPressed: () => Get.back(),
              ),
              centerTitle: true,
              title: Text(
                trackingId.toString(),
                style: AppThemeData.headerTextStyle_14
                    .copyWith(color: Colors.white),
              ),
            ),
      body: Obx(
        () => invoiceScreenController.isLoading.value
            ? _buildInvoice(context)
            : const ShimmerInvoice(),
      ),
    );
  }

  Widget _buildInvoice(BuildContext context) {
    final order = invoiceScreenController.trackingOrderModel!.data!.order!;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 15.h),
            child: Column(
              children: [
                // ── En-tête facture ──
                _card(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/logos/logo.png',
                          height: 40.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Divider(height: 1, color: const Color(0xFFEEEEEE)),
                      SizedBox(height: 12.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppTags.invoice.tr,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: isMobile(context) ? 12.sp : 9.sp,
                                    color: _grey,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "#${trackingId.toString()}",
                                  style: TextStyle(
                                    fontFamily: "Poppins Medium",
                                    fontWeight: FontWeight.w700,
                                    fontSize: isMobile(context) ? 16.sp : 12.sp,
                                    color: _dark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _statusBadge(
                              context, order.paymentStatus?.toString() ?? ''),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Divider(height: 1, color: const Color(0xFFEEEEEE)),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 14.r, color: _grey),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              "${AppTags.orderDate.tr}: ${order.date?.toString() ?? ''}",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: isMobile(context) ? 12.sp : 9.sp,
                                color: _dark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // ── Articles ──
                _card(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(context, AppTags.products.tr),
                      ...List.generate(
                        order.orderDetails!.length,
                        (i) {
                          final item = order.orderDetails![i];
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.productName?.toString() ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              fontSize: isMobile(context)
                                                  ? 13.sp
                                                  : 10.sp,
                                              color: _dark,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            "${AppTags.qty.tr}: ${item.quantity.toString()}",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: isMobile(context)
                                                  ? 11.sp
                                                  : 8.sp,
                                              color: _grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      currencyConverterController
                                          .convertCurrency(item
                                              .formattedTotalPayable
                                              .toString()),
                                      style: TextStyle(
                                        fontFamily: "Poppins Medium",
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            isMobile(context) ? 13.sp : 10.sp,
                                        color: _dark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (i != order.orderDetails!.length - 1)
                                Divider(
                                    height: 1, color: const Color(0xFFF0F0F0)),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // ── Informations client ──
                if (order.billingAddress != null)
                  _card(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(context, AppTags.accountDetails.tr),
                        _infoRow(context, AppTags.name.tr,
                            order.billingAddress!.name?.toString() ?? ''),
                        _infoRow(context, AppTags.email.tr,
                            order.billingAddress!.email?.toString() ?? ''),
                        _infoRow(context, AppTags.shippingAddress.tr,
                            order.billingAddress!.address?.toString() ?? '',
                            maxLines: 3),
                        _infoRow(context, AppTags.paymentStatus.tr,
                            order.paymentStatus?.toString() ?? ''),
                        _infoRow(context, AppTags.deliveryStatus.tr,
                            order.orderStatus?.toString() ?? ''),
                      ],
                    ),
                  ),
                // ── Récapitulatif ──
                _card(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _summaryRow(
                          context,
                          AppTags.subtotal.tr,
                          currencyConverterController.convertCurrency(
                              order.formattedSubTotal.toString())),
                      _summaryRow(
                          context,
                          AppTags.discountOffer.tr,
                          currencyConverterController.convertCurrency(
                              order.formattedDiscount.toString())),
                      _summaryRow(
                          context,
                          AppTags.deliveryCharge.tr,
                          currencyConverterController.convertCurrency(
                              order.formattedShippingCost.toString())),
                      _summaryRow(
                          context,
                          AppTags.tax.tr,
                          currencyConverterController
                              .convertCurrency(order.formattedTax.toString())),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Divider(
                            height: 1, color: const Color(0xFFEEEEEE)),
                      ),
                      _summaryRow(
                          context,
                          AppTags.totalCost.tr,
                          currencyConverterController.convertCurrency(
                              order.formattedTotalPayable.toString()),
                          isTotal: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // ── Bouton télécharger ──
        Padding(
          padding: EdgeInsets.fromLTRB(15.w, 8.h, 15.w, 20.h),
          child: SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton.icon(
              onPressed: () => _downloadInvoice(context, order),
              icon: Icon(Icons.download_rounded,
                  color: Colors.white, size: 18.r),
              label: Text(
                AppTags.downloadInvoice.tr,
                style: isMobile(context)
                    ? AppThemeData.buttonTextStyle_14
                    : AppThemeData.buttonTextStyle_11Tab,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeData.buttonColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Génère la facture en PDF dans l'app puis ouvre le partage (Enregistrer
  // dans Fichiers / Téléchargements). Ne dépend plus du backend.
  Future<void> _downloadInvoice(BuildContext context, Order order) async {
    // iOS exige un rectangle d'ancrage pour la feuille de partage (iPad/iPhone).
    final box = context.findRenderObject() as RenderBox?;
    final Rect? origin =
        box != null ? box.localToGlobal(Offset.zero) & box.size : null;
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final bytes = await InvoicePdfGenerator.generate(
        order: order,
        invoiceNo: trackingId.toString(),
        convert: (s) =>
            currencyConverterController.convertCurrency((s ?? '').toString()),
      );
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/Facture-${trackingId.toString()}.pdf');
      await file.writeAsBytes(bytes);
      if (Get.isDialogOpen ?? false) Get.back();
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: '${AppTags.invoice.tr} #${trackingId.toString()}',
          sharePositionOrigin: origin,
        ),
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar(AppTags.invoice.tr, e.toString());
    }
  }

  // ── Helpers UI ──
  Widget _card(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEDEDED)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Poppins Medium",
          fontWeight: FontWeight.w600,
          fontSize: isMobile(context) ? 14.sp : 11.sp,
          color: _dark,
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value,
      {int maxLines = 2}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontFamily: "Poppins Medium",
              fontSize: isMobile(context) ? 13.sp : 10.sp,
              color: _grey,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: isMobile(context) ? 13.sp : 10.sp,
                color: _dark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value,
      {bool isTotal = false}) {
    final style = TextStyle(
      fontFamily: isTotal ? "Poppins Medium" : "Poppins",
      fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
      fontSize: isMobile(context)
          ? (isTotal ? 15.sp : 13.sp)
          : (isTotal ? 12.sp : 10.sp),
      color: isTotal ? _brand : const Color(0xFF444444),
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }

  Widget _statusBadge(BuildContext context, String status) {
    final bool isUnpaid = status.toLowerCase() == "unpaid";
    final Color color = isUnpaid ? _brand : _green;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isUnpaid ? Icons.cancel : Icons.check_circle,
              size: 13.r, color: color),
          SizedBox(width: 4.w),
          Text(
            isUnpaid ? AppTags.unpaid.tr : AppTags.paid.tr,
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: isMobile(context) ? 11.sp : 9.sp,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
