import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yoori_ecommerce/src/_route/routes.dart';
import '../../../controllers/payment_controller.dart';
import '../../../servers/network_service.dart';
import '../../../utils/app_tags.dart';
import '../../../utils/app_theme_data.dart';
import '../../../utils/constants.dart';
import '../../../../../config.dart';
import '../../../controllers/currency_converter_controller.dart';
import '../../../data/local_data_helper.dart';
import 'package:yoori_ecommerce/src/utils/responsive.dart';
import '../../../widgets/loader/loader_widget.dart';


class PaymentScreen extends GetView<PaymentController> {
  PaymentScreen({super.key});
  final currencyConverterController = Get.find<CurrencyConverterController>();
  final String trxId = Get.parameters['trxId']!;
  final String token = Get.parameters['token']!;
  final String langCurrCode = "lang=${LocalDataHelper().getLangCode()??"en"}&curr=${LocalDataHelper().getCurrCode()??""}";

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(
      builder: (paymentController) {
        printLog("-------   ${NetworkService.apiUrl}/payment?trx_id=$trxId&$langCurrCode");
        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            backgroundColor: AppThemeData.homeAppBarColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              AppTags.paymentGateway.tr,
              style: isMobile(context)
                  ? AppThemeData.headerTextStyle_16.copyWith(color: Colors.white)
                  : AppThemeData.headerTextStyle_16.copyWith(fontSize: 13.sp, color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      InAppWebView(
                        key: paymentController.webViewKey,
                        initialUrlRequest: URLRequest(
                          url: token.isNotEmpty
                              ? WebUri("${NetworkService.apiUrl}/payment?trx_id=$trxId&token=$token&$langCurrCode")
                              : WebUri("${NetworkService.apiUrl}/payment?trx_id=$trxId&$langCurrCode"),
                        ),
                        initialUserScripts:
                            UnmodifiableListView<UserScript>([]),
                        initialOptions: paymentController.options,
                        pullToRefreshController:
                            paymentController.pullToRefreshController,
                        onWebViewCreated: (controller) {
                          paymentController.webViewController = controller;
                        },
                        onCreateWindow: (controller, createWindowAction) async {
                          final url = createWindowAction.request.url;
                          if (url != null) {
                            controller.loadUrl(urlRequest: URLRequest(url: url));
                          }
                          return true;
                        },
                        onLoadStart: (controller, url) {
                          printLog(url.toString());
                          if (url == Uri.parse("${Config.apiServerUrl}/payment-success")) {
                            Get.offAllNamed(Routes.paymentConfirm);
                          }
                        },
                        androidOnPermissionRequest:
                            (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          if (url == Uri.parse("${Config.apiServerUrl}/payment-success")) {
                            Get.offAllNamed(Routes.paymentConfirm);
                          }
                          paymentController.isLoadingUpdate(false);
                          paymentController.pullToRefreshController
                              .endRefreshing();
                          paymentController.webViewController!
                              .evaluateJavascript(
                                  source: "javascript:(function() { "
                                      "var order = document.getElementById('order_btn');"
                                      "order.parentNode.removeChild(order);"
                                      "})()")
                              .then((value) => debugPrint(
                                  'Page finished loading Javascript'))
                              .catchError((onError) => debugPrint('$onError'));

                          paymentController.webViewController!
                              .evaluateJavascript(
                                  source: "javascript:(function() { "
                                      "var shipping = document.getElementById('shipping_btn');"
                                      "shipping.parentNode.removeChild(shipping);"
                                      "})()")
                              .then((value) => debugPrint(
                                  'Page finished loading Javascript'))
                              .catchError((onError) => debugPrint('$onError'));

                          paymentController.webViewController!
                              .evaluateJavascript(
                                  source: "(function() { "
                                      "var style = document.createElement('style');"
                                      "style.innerHTML = '.btn-primary, .paymentBTNFixed { background-color: #FF0008 !important; border-color: #FF0008 !important; color: #ffffff !important; } .btn-primary:disabled, .paymentBTNFixed.disable_btn { background-color: #FF0008 !important; border-color: #FF0008 !important; color: #ffffff !important; opacity: 0.85; }';"
                                      "document.head.appendChild(style);"
                                      "})()")
                              .then((value) => debugPrint(
                                  'Payment button style injected'))
                              .catchError((onError) => debugPrint('$onError'));
                        },
                        onLoadError: (controller, url, code, message) {
                          paymentController.pullToRefreshController
                              .endRefreshing();
                        },
                        onProgressChanged: (controller, progress) {
                          paymentController.progressUpdate(progress);

                          if (progress == 100) {
                            paymentController.pullToRefreshController
                                .endRefreshing();
                          }
                        },
                        onUpdateVisitedHistory:
                            (controller, url, androidIsReload) {},
                        onConsoleMessage: (controller, consoleMessage) {},
                      ),
                      paymentController.isLoading
                          ? const Center(child: LoaderWidget())
                          : Container(),
                      Positioned(
                        bottom: 100.h,
                        child: Column(
                          children: [
                            if (paymentController.showButton) ...[
                              SizedBox(
                                width: 160.w,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppThemeData.homeAppBarColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  onPressed: () => Get.toNamed(Routes.dashboardScreen),
                                  child: Text(
                                    AppTags.continueShopping.tr,
                                    style: TextStyle(fontSize: 13.sp, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              SizedBox(
                                width: 160.w,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppThemeData.homeAppBarColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  onPressed: () => Get.toNamed(Routes.categoryContent),
                                  child: Text(
                                    AppTags.viewOrder.tr,
                                    style: TextStyle(fontSize: 13.sp, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
