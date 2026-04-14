import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/currency_converter_controller.dart';
import '../../controllers/invoice_screen_controller.dart';
import '../../servers/network_service.dart';
import '../../data/local_data_helper.dart';
import '../../utils/app_theme_data.dart';
import 'package:yoori_ecommerce/src/utils/app_tags.dart';
import 'package:yoori_ecommerce/src/utils/responsive.dart';
import '../../widgets/loader/shimmer_invoice.dart';

class InvoiceScreen extends StatelessWidget {
  InvoiceScreen({super.key});
  final trackingId = Get.parameters['trackingId'];

  final currencyConverterController = Get.find<CurrencyConverterController>();
  final InvoiceScreenController invoiceScreenController = Get.put(InvoiceScreenController());

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
          trackingId.toString(),
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
        title: Text(trackingId.toString(),
          style: AppThemeData.headerTextStyle_14.copyWith(color: Colors.white),
        ),
      ),
      body: Obx(()=> invoiceScreenController.isLoading.value
          ? Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                height: 250.h,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: AppThemeData.invoiceDividerColor,
                    ),
                    child: DataTable(
                      sortColumnIndex: 1,
                      sortAscending: true,
                      columnSpacing: 8,
                      // dataRowMinHeight: 70,
                      columns: [
                        DataColumn(
                          label: Text(
                            '#',
                            style: TextStyle(
                              fontSize: isMobile(context)? 14.sp:11.sp,
                              fontFamily: "Poppins Medium",
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            AppTags.products.tr,
                            style: TextStyle(
                              fontSize: isMobile(context)? 14.sp:11.sp,
                              fontFamily: "Poppins Medium",
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            AppTags.qty.tr,
                            style:  TextStyle(
                              fontSize: isMobile(context)? 14.sp:11.sp,
                              fontFamily: "Poppins Medium",
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            AppTags.total.tr,
                            style:  TextStyle(
                              fontSize: isMobile(context)? 14.sp:11.sp,
                              fontFamily: "Poppins Medium",
                            ),
                          ),
                        ),
                      ],
                      rows: invoiceScreenController.trackingOrderModel!.data!.order!.orderDetails!
                          .map(
                            (invoice) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                invoice.id.toString().padLeft(2, "0"),
                                style:  TextStyle(
                                  fontSize: isMobile(context)? 13.sp:10.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 180.w,
                                height: 37.h,
                                child: Text(
                                  invoice.productName!.toString(),
                                  style: TextStyle(
                                    fontSize: isMobile(context)? 13.sp:10.sp,
                                    color: Colors.black,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                invoice.quantity
                                    .toString()
                                    .padLeft(2, "0"),
                                style: TextStyle(
                                  fontSize: isMobile(context)? 13.sp:10.sp,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            DataCell(
                              Text(
                                currencyConverterController
                                    .convertCurrency(invoice
                                    .formattedTotalPayable!
                                    .toString()),
                                style:  TextStyle(
                                  fontSize: isMobile(context)? 13.sp:10.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).toList(),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              color: AppThemeData.invoiceDividerColor,
              thickness: 1,
            ),
            SizedBox(height: 15.h),
            invoiceScreenController.trackingOrderModel!.data!.order!.billingAddress != null
                ? Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.r),),
                border: Border.all(
                  color: AppThemeData.invoiceDividerColor,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.h,),
                    Text(
                      AppTags.accountDetails.tr,
                      style: TextStyle(
                        fontSize: isMobile(context)? 14.sp:11.sp,
                        fontFamily: "Poppins Medium",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppTags.name.tr}:",
                          style: TextStyle(
                            fontSize: isMobile(context) ? 13.sp : 10.sp,
                            fontFamily: "Poppins Medium",
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            invoiceScreenController.trackingOrderModel!
                                .data!.order!.billingAddress!.name!
                                .toString(),
                            style: TextStyle(
                              fontSize: isMobile(context) ? 13.sp : 10.sp,
                            ),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppTags.email.tr}:",
                          style: TextStyle(
                            fontSize: isMobile(context) ? 13.sp : 10.sp,
                            fontFamily: "Poppins Medium",
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            invoiceScreenController.trackingOrderModel!
                                .data!.order!.billingAddress!.email!
                                .toString(),
                            style: TextStyle(
                              fontSize: isMobile(context) ? 13.sp : 10.sp,
                            ),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppTags.shippingAddress.tr}:",
                          style: TextStyle(
                            fontSize: isMobile(context) ? 13.sp : 10.sp,
                            fontFamily: "Poppins Medium",
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            invoiceScreenController.trackingOrderModel!
                                .data!.order!.billingAddress!.address
                                .toString(),
                            style: TextStyle(
                              fontSize: isMobile(context) ? 13.sp : 10.sp,
                            ),
                            maxLines: 3,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppTags.orderDate.tr}:",
                          style: TextStyle(
                            fontSize: isMobile(context) ? 13.sp : 10.sp,
                            fontFamily: "Poppins Medium",
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            invoiceScreenController.trackingOrderModel!
                                .data!.order!.date!
                                .toString(),
                            style: TextStyle(
                              fontSize: isMobile(context) ? 13.sp : 10.sp,
                            ),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppTags.paymentStatus.tr}:",
                          style: TextStyle(
                            fontSize: isMobile(context) ? 13.sp : 10.sp,
                            fontFamily: "Poppins Medium",
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            invoiceScreenController.trackingOrderModel!
                                .data!.order!.paymentStatus!
                                .toString(),
                            style: TextStyle(
                              fontSize: isMobile(context) ? 13.sp : 10.sp,
                            ),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppTags.deliveryStatus.tr}:",
                          style: TextStyle(
                            fontSize: isMobile(context) ? 13.sp : 10.sp,
                            fontFamily: "Poppins Medium",
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            invoiceScreenController.trackingOrderModel!
                                .data!.order!.orderStatus
                                .toString(),
                            style: TextStyle(
                              fontSize: isMobile(context) ? 13.sp : 10.sp,
                            ),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),
            )
                : Container(height: 80.h),
            SizedBox(
              height: 15.h,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.r),
                ),
                border: Border.all(
                  color: AppThemeData.invoiceDividerColor,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppTags.subtotal.tr,
                          style: TextStyle(
                            fontSize: isMobile(context)? 13.sp:10.sp,
                          ),
                        ),
                        Text(
                          currencyConverterController.convertCurrency(
                              invoiceScreenController.trackingOrderModel!
                                  .data!.order!.formattedSubTotal
                                  .toString()),
                          style:  TextStyle(
                            fontSize: isMobile(context)? 13.sp:10.sp,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppTags.discountOffer.tr,
                          style:  TextStyle(
                            fontSize: isMobile(context)? 13.sp:10.sp,
                          ),
                        ),
                        Text(
                          currencyConverterController.convertCurrency(
                              invoiceScreenController.trackingOrderModel!
                                  .data!.order!.formattedDiscount
                                  .toString()),
                          style: TextStyle(
                            fontSize: isMobile(context)? 13.sp:10.sp,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppTags.deliveryCharge.tr,
                          style: TextStyle(
                            fontSize: isMobile(context)? 13.sp:10.sp,
                          ),
                        ),
                        Text(
                          currencyConverterController.convertCurrency(
                              invoiceScreenController.trackingOrderModel!
                                  .data!.order!.formattedShippingCost
                                  .toString()),
                          style:  TextStyle(
                            fontSize: isMobile(context)? 13.sp:10.sp,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppTags.tax.tr,
                          style: TextStyle(
                            fontSize: isMobile(context)? 13.sp:10.sp,
                          ),
                        ),
                        Text(
                          currencyConverterController.convertCurrency(
                              invoiceScreenController.trackingOrderModel!
                                  .data!.order!.formattedTax
                                  .toString()),
                          style:  TextStyle(
                            fontSize: isMobile(context)? 13.sp:10.sp,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: AppThemeData.invoiceDividerColor,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppTags.totalCost.tr,
                          style:  TextStyle(
                            fontSize: isMobile(context)? 13.sp:10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          currencyConverterController.convertCurrency(
                              invoiceScreenController.trackingOrderModel!
                                  .data!.order!.formattedTotalPayable
                                  .toString()),
                          style:  TextStyle(
                            fontSize: isMobile(context)? 13.sp:10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () async {
                  Uri url = Uri.parse(
                      "${NetworkService.apiUrl}/invoice-download/${invoiceScreenController.trackingOrderModel!.data!.order!.id}?token=${LocalDataHelper().getUserToken()}");

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'could not launch $url';
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeData.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Text(
                    AppTags.downloadInvoice.tr,
                    style: isMobile(context)? AppThemeData.buttonTextStyle_14:AppThemeData.buttonTextStyle_11Tab,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ) : const ShimmerInvoice(),)

    );
  }
}
