import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yoori_ecommerce/src/models/home_data_model.dart';
import 'package:yoori_ecommerce/src/data/local_data_helper.dart';
import 'package:yoori_ecommerce/src/servers/repository.dart';
import 'package:yoori_ecommerce/src/utils/app_theme_data.dart';

class HomeScreenController extends GetxController implements GetxService {
  PageController pageController = PageController();
  final CarouselSliderController controller = CarouselSliderController();
  var current = 1.obs;
  bool isVisible = true;
  var index = 2;
  bool isFavourite = false;

  Rx<HomeDataModel> homeDataModel = HomeDataModel.empty().obs;
  var isLoadingFromServer = false.obs;
  var hasError = false.obs;
  RxList<Map<String, dynamic>> localRecentProducts = <Map<String, dynamic>>[].obs;

  void refreshLocalRecent() {
    localRecentProducts.value = LocalDataHelper().getRecentlyViewed();
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.wifi_off_rounded, size: 32.w, color: AppThemeData.homeAppBarColor),
              ),
              SizedBox(height: 16.h),
              Text(
                'Erreur de connexion',
                style: TextStyle(
                  fontFamily: 'Poppins Medium',
                  fontSize: 16.sp,
                  color: AppThemeData.headlineTextColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.sp,
                  color: AppThemeData.descriptionTextColor,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppThemeData.homeAppBarColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Fermer',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.sp,
                          color: AppThemeData.headlineTextColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        getHomeDataFromServer();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemeData.homeAppBarColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                      ),
                      child: Text(
                        'Réessayer',
                        style: TextStyle(
                          fontFamily: 'Poppins Medium',
                          fontSize: 13.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> getHomeScreenData() async {
    try {
      isLoadingFromServer(true);
      hasError(false);

      HomeDataModel? cached = LocalDataHelper().getHomeData();
      if (cached != null && cached.data != null && cached.data!.isNotEmpty) {
        homeDataModel.value = cached;
        isLoadingFromServer(false);
      }

      final homeData = await Repository().getHomeScreenData();
      homeDataModel.value = homeData;
      LocalDataHelper().saveHomeContent(homeData);

    } catch (e) {
      print("❌ HomeScreenController.getHomeScreenData erreur: $e");
      hasError(true);
      _showErrorDialog('Impossible de charger la page d\'accueil.\nVérifiez votre connexion internet.');
    } finally {
      isLoadingFromServer(false);
    }
  }

  Future<void> getHomeDataFromServer() async {
    try {
      isLoadingFromServer(true);
      hasError(false);

      final homeData = await Repository().getHomeScreenData();
      homeDataModel.value = homeData;
      LocalDataHelper().saveHomeContent(homeData);

    } catch (e) {
      print("❌ HomeScreenController.getHomeDataFromServer erreur: $e");
      hasError(true);
      _showErrorDialog('Impossible de rafraîchir les données.\nVérifiez votre connexion internet.');
    } finally {
      isLoadingFromServer(false);
    }
  }

  String removeTrailingZeros(String n) {
    return n.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }

  @override
  void onInit() {
    super.onInit();
    LocalDataHelper().clearHomeContent(); // force refresh pour corriger les URLs d'images cachées
    refreshLocalRecent();
    getHomeScreenData();
  }

  void isVisibleUpdate(bool value) {
    isVisible = value;
    update();
  }

  void currentUpdate(int value) {
    current.value = value;
    update();
  }

  void isFavouriteUpdate() {
    isFavourite = !isFavourite;
    update();
  }
}