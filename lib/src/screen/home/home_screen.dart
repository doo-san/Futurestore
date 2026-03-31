import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:yoori_ecommerce/src/_route/routes.dart';
import 'package:yoori_ecommerce/src/models/home_data_model.dart';
import 'package:yoori_ecommerce/src/utils/images.dart';
import '../../controllers/cart_content_controller.dart';
import '../../controllers/currency_converter_controller.dart';
import '../../controllers/details_screen_controller.dart';
import '../../controllers/home_screen_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../screen/drawer/drawer_screen.dart';
import '../../screen/news/all_news_screen.dart';
import 'package:yoori_ecommerce/src/utils/app_tags.dart';
import '../../utils/app_theme_data.dart';
import 'package:yoori_ecommerce/src/utils/responsive.dart';
import '../../widgets/product_card_widgets/home_product_card.dart';
import '../../widgets/loader/shimmer_home_content.dart';
import '../../widgets/shop_card_widget.dart';
import 'campaign/all_campaign_screen.dart';
import 'campaign/campaign_screen.dart';
import 'category/all_product_screen.dart';
import 'category/all_shop_screen.dart';
import 'category/best_selling_products_screen.dart';
import 'category/best_shop_screen.dart';
import 'category/flash_sales_screen.dart';
import 'category/offer_ending_product_screen.dart';
import 'category/product_by_brand_screen.dart';
import 'category/product_by_category_screen.dart';
import 'category/product_by_shop_screen.dart';
import 'category/recent_view_product_screen.dart';
import 'category/today_deals_screen.dart';
import 'category/top_shop_screen.dart';
import 'video_shopping/all_video_shopping.dart';

class HomeScreenContent extends StatelessWidget {
  HomeScreenContent({super.key});

  final DashboardController homeScreenController =
  Get.find<DashboardController>();
  final _cartController = Get.find<CartContentController>();
  final homeScreenContentController = Get.find<HomeScreenController>();
  final detailsPageController = Get.lazyPut(
        () => DetailsPageController(),
    fenix: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: isMobile(context)
          ? AppBar(
        backgroundColor: const Color(0xFFFE840C),
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: SvgPicture.asset(Images.menuBar,
                  color: Colors.white, height: 20.h),
              tooltip:
              MaterialLocalizations.of(context).openAppDrawerTooltip,
              onPressed: () {
                Scaffold.of(context).openDrawer();
                homeScreenContentController.isVisibleUpdate(false);
              },
            );
          },
        ),
        title: InkWell(
          onTap: () => Get.toNamed(Routes.searchProduct),
          child: Container(
            height: 35.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color:
                  AppThemeData.boxShadowColor.withOpacity(0.10),
                  spreadRadius: 0,
                  blurRadius: 5.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: SvgPicture.asset(
                    Images.searchBar,
                    color: AppThemeData.searchIconColor,
                    width: 18.w,
                    height: 18.h,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 8.h),
                  child: const VerticalDivider(thickness: 2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(AppTags.searchProduct.tr,
                      style: AppThemeData.hintTextStyle_13),
                )
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              Images.notification,
              color: Colors.white,
              height: 22.h,
              width: 19.w,
            ),
            onPressed: () => Get.toNamed(Routes.notificationContent),
          ),
        ],
      )
          : AppBar(
        backgroundColor: const Color(0xFFFE840C),
        elevation: 0,
        toolbarHeight: 60.h,
        leadingWidth: 40.w,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: SvgPicture.asset(Images.menuBar, height: 20.h),
              tooltip:
              MaterialLocalizations.of(context).openAppDrawerTooltip,
              onPressed: () {
                Scaffold.of(context).openDrawer();
                homeScreenContentController.isVisibleUpdate(false);
              },
            );
          },
        ),
        title: InkWell(
          onTap: () => Get.toNamed(Routes.searchProduct),
          child: Container(
            height: 35.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color:
                  AppThemeData.boxShadowColor.withOpacity(0.10),
                  spreadRadius: 0,
                  blurRadius: 5.r,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: SvgPicture.asset(
                    Images.searchBar,
                    color: AppThemeData.searchIconColor,
                    width: 18.w,
                    height: 18.h,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 8.h),
                  child: const VerticalDivider(thickness: 2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(AppTags.searchProduct.tr,
                      style: AppThemeData.hintTextStyle_10Tab),
                )
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: IconButton(
              icon: SvgPicture.asset(
                Images.notification,
                height: 22.h,
                width: 19.w,
              ),
              onPressed: () => Get.toNamed(Routes.notificationContent),
            ),
          ),
        ],
      ),
      drawer: const DrawerScreen(),

      // ✅ CORRECTION PRINCIPALE : Obx uniquement sur le body
      // Avant : Obx enveloppait tout le Scaffold + une condition stricte
      // qui bloquait l'affichage si le panier n'était pas chargé.
      // Maintenant : seul le body est réactif, le Scaffold est stable.
      body: Obx(() {

        // ── État : chargement en cours ─────────────────────────
        if (homeScreenContentController.isLoadingFromServer.value) {
          return const ShimmerHomeContent();
        }

        final sections =
            homeScreenContentController.homeDataModel.value.data ?? [];

        // ── État : erreur ou données vides ────────────────────
        if (sections.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'Impossible de charger les données',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: homeScreenContentController.getHomeDataFromServer,
                  child: Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        // ── État : données disponibles ─────────────────────────
        return RefreshIndicator(
          onRefresh: homeScreenContentController.getHomeDataFromServer,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: sections.length,
            itemBuilder: (context, index) {

              final section = sections[index];

              // ✅ Section sans type → on skip silencieusement
              if (section.sectionType == null ||
                  section.sectionType!.isEmpty) {
                return const SizedBox.shrink();
              }

              return categoryCheck(
                homeScreenContentController.homeDataModel.value,
                index,
                context,
              );
            },
          ),
        );
      }),
    );
  }

  //Top Category
  Widget topCategories(topCategoriesIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![topCategoriesIndex].topCategories;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                AppTags.topCategories.tr,
                style: isMobile(context)
                    ? AppThemeData.headerTextStyle
                    : AppThemeData.headerTextStyleTab,
              ),
            ),
            InkWell(
              onTap: () => homeScreenController.changeTabIndex(1),
              child: Padding(
                padding: EdgeInsets.all(15.0.r),
                child: SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 150.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ProductByCategory(
                        id: item.id ?? 0,
                        title: item.title,
                      ),
                    ));
                  },
                  child: Container(
                    height: 150.h,
                    width: isMobile(context) ? 105.w : 80.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(7.r)),
                      border: Border.all(width: 1, color: const Color(0xFFEEEEEE)),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: item.image != null
                                ? CachedNetworkImage(
                              imageUrl: item.image!,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                              ),
                            )
                                : const SizedBox(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 3.h),
                          child: Text(
                            item.title ?? '',
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: AppThemeData.todayDealTitleStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  //Popular Categories
  Widget popularCategories(popularCategoriesIndex, context) {
    final items = homeScreenContentController.homeDataModel.value
        .data![popularCategoriesIndex].popularCategories;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                AppTags.popularCategories.tr,
                style: isMobile(context)
                    ? AppThemeData.headerTextStyle
                    : AppThemeData.headerTextStyleTab,
              ),
            ),
            InkWell(
              onTap: () => homeScreenController.changeTabIndex(1),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child: SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        SizedBox(
          height: 95.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ProductByCategory(
                      id: item.id ?? 0,
                      title: item.title,
                    ),
                  ));
                },
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: Column(
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppThemeData.homeMultipleColor[
                              index % AppThemeData.homeMultipleColor.length]
                                  .withOpacity(0.1),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.5.r),
                              child: item.icon == null || item.icon!.isEmpty
                                  ? const SizedBox()
                                  : Icon(
                                MdiIcons.fromString(
                                    item.icon!.substring(8)),
                                size: 32.r,
                                color: AppThemeData.homeMultipleColor[
                                index % AppThemeData.homeMultipleColor.length],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          SizedBox(
                            width: 58.w,
                            child: Text(
                              item.title.toString(),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: isMobile(context)
                                  ? AppThemeData.titleTextStyle_13
                                  : AppThemeData.titleTextStyleTab,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Categories
  Widget _categories(categoryIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![categoryIndex].categories;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Container(
        height: isMobile(context) ? 30.h : 40.h,
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 6.w),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProductByCategory(
                            id: item.id,
                            title: item.title,
                          ),
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 4.h),
                        child: Text(
                          item.title.toString(),
                          style: isMobile(context)
                              ? AppThemeData.categoryTextStyle_14
                              : AppThemeData.categoryTitleTextStyle_12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: isMobile(context) ? 15.w : 10.w),
                  child: Container(
                    height: 15.h,
                    width: 1.5.w,
                    color: Colors.grey,
                  ),
                ),
                InkWell(
                  onTap: () => homeScreenController.changeTabIndex(1),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isMobile(context) ? 15.w : 10.w,
                        vertical: 0.h),
                    child: SvgPicture.asset(Images.subMenu,
                        height: 12.h, width: 12.w),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Popular Brands
  Widget popularBrands(brandIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![brandIndex].popularBrands;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                AppTags.popularBrands.tr,
                style: isMobile(context)
                    ? AppThemeData.headerTextStyle
                    : AppThemeData.headerTextStyleTab,
              ),
            ),
            InkWell(
              onTap: () => Get.toNamed(Routes.allBrand),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child: SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile(context) ? 0.h : 8.h),
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 15.w, bottom: 15.h),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ProductByBrand(
                        id: item.id ?? 0,
                        title: item.title ?? '',
                      ),
                    ));
                  },
                  child: Container(
                    height: 110.h,
                    width: isMobile(context) ? 110.w : 70.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      boxShadow: [
                        BoxShadow(
                          color:
                          AppThemeData.boxShadowColor.withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 30.r,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: item.thumbnail != null
                          ? CachedNetworkImage(
                              imageUrl: item.thumbnail!,
                              errorWidget: (_, __, ___) => Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //Slider
  Widget slider(sliderIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![sliderIndex].slider;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: [
        CarouselSlider(
          carouselController: homeScreenContentController.controller,
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              homeScreenContentController.currentUpdate(index);
            },
            height: isMobile(context) ? 140.h : 150.h,
            autoPlayInterval: const Duration(seconds: 6),
            viewportFraction: isMobile(context) ? 0.92 : 0.58,
            aspectRatio: 16 / 4,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            autoPlay: true,
          ),
          items: items.map((item) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(0.0),
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      if (item.actionType == "product") {
                        Get.toNamed(Routes.detailsPage,
                            parameters: {'productId': (item.id ?? 0).toString()});
                      } else if (item.actionType == "category") {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProductByCategory(
                              id: item.id ?? 0, title: item.title.toString()),
                        ));
                      } else if (item.actionType == "brand") {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              ProductByBrand(id: item.id ?? 0, title: "Brand"),
                        ));
                      } else if (item.actionType == "seller") {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              ProductByShop(id: item.id ?? 0, shopName: "Shop"),
                        ));
                      } else if (item.actionType == "url") {
                        Get.toNamed(Routes.wvScreen, parameters: {
                          'url': item.actionTo.toString(),
                          'title': "",
                        });
                      } else if (item.actionType == "blog") {
                        Get.toNamed(Routes.newsScreen, parameters: {
                          'title': item.title.toString(),
                          'url': item.url.toString(),
                          'image': item.backgroundImage.toString(),
                        });
                      }
                    },
                    child: SizedBox(
                      height: 140.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: item.banner != null
                            ? CachedNetworkImage(
                          imageUrl: item.banner!,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                          ),
                        )
                            : const SizedBox(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        Positioned(
          bottom: isMobile(context) ? 0.h : 5.h,
          left: 0.w,
          right: 0.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: items.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  homeScreenContentController.controller
                      .animateToPage(entry.key);
                  homeScreenContentController.currentUpdate(entry.key);
                },
                child: Obx(
                      () => Container(
                    width: homeScreenContentController.current.value ==
                        entry.key
                        ? 20.0.w
                        : 10.w,
                    height: 3.0.h,
                    margin:
                    EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(8.r)),
                      color:
                      homeScreenContentController.current.value == entry.key
                          ? const Color(0xff333333)
                          : const Color(0xff999999),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  //Banner
  Widget banner(bannerIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![bannerIndex].banners;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: isMobile(context) ? 10.h : 30.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: isMobile(context) ? 90.h : 110.h,
            width: double.infinity,
            child: ListView.builder(
              padding: EdgeInsets.only(right: 0.w),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final data = items[index];
                return InkWell(
                  onTap: () {
                    if (data.actionType == "product" &&
                        data.actionId != null &&
                        data.actionId!.isNotEmpty) {
                      Get.toNamed(Routes.detailsPage,
                          parameters: {'productId': data.actionId!});
                    } else if (data.actionType == "category" &&
                        data.actionId != null &&
                        data.actionId!.isNotEmpty) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ProductByCategory(
                          id: int.parse(data.actionId!),
                          title: data.actionTo.toString(),
                        ),
                      ));
                    } else if (data.actionType == "brand" &&
                        data.actionId != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ProductByBrand(
                          id: int.parse(data.actionId!),
                          title: data.actionTo.toString(),
                        ),
                      ));
                    } else if (data.actionType == "seller") {
                      Get.toNamed(Routes.shopScreen,
                          parameters: {'shopId': data.actionId!});
                    } else if (data.actionType == "url") {
                      Get.toNamed(Routes.wvScreen, parameters: {
                        'url': data.actionId.toString(),
                        'title': data.actionTo.toString(),
                      });
                    } else if (data.actionType == "blog") {
                      Get.toNamed(Routes.newsScreen, parameters: {
                        'title': data.actionTo.toString(),
                        'url': data.actionId.toString(),
                        'image': data.thumbnail.toString(),
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: Container(
                      width: 159.w,
                      decoration: BoxDecoration(
                        image: data.thumbnail != null
                            ? DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                                data.thumbnail!))
                            : null,
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.r)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 14.h),
        ],
      ),
    );
  }

  //Category Banner
  Widget categorySecBanner(catSecIndex, context) {
    final url = homeScreenContentController.homeDataModel.value.data![catSecIndex].categorySecBanner?.toString() ?? '';
    return SizedBox(
      height: 100.h,
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h, bottom: 10.h),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          child: url.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: url,
                  width: MediaQuery.of(context).size.width - 30,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(color: Colors.grey.shade200),
                )
              : Container(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  //Offer Ending Banner
  Widget offerEndingBanner(offerEndingIndex, context) {
    final url = homeScreenContentController.homeDataModel.value.data![offerEndingIndex].offerEnding?.toString() ?? '';
    return SizedBox(
      height: 100.h,
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h, bottom: 10.h),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          child: url.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: url,
                  width: MediaQuery.of(context).size.width - 30,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(color: Colors.grey.shade200),
                )
              : Container(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  //Campaign
  Widget campaign(campaignIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![campaignIndex].campaigns;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(AppTags.campaign.tr,
                  style: isMobile(context)
                      ? AppThemeData.headerTextStyle
                      : AppThemeData.headerTextStyleTab),
            ),
            InkWell(
              onTap: () => Get.to(() => const AllCampaign()),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child:
                SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        SizedBox(
          height: isMobile(context) ? 100.h : 120.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CampaignContentScreen(
                        campainId: item.id ?? 0,
                        title: item.title ?? '',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: Container(
                    width: isMobile(context) ? 165.w : 140.w,
                    decoration: BoxDecoration(
                      image: item.banner != null
                          ? DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(item.banner!))
                          : null,
                      borderRadius:
                      BorderRadius.all(Radius.circular(8.r)),
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 14.h),
      ],
    );
  }

  // Featured Shop
  Widget featuredShop(featureShopIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![featureShopIndex].featuredShops;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(AppTags.featuredShop.tr,
                  style: isMobile(context)
                      ? AppThemeData.headerTextStyle
                      : AppThemeData.headerTextStyleTab),
            ),
            InkWell(
              onTap: () => Get.to(() => const AllShop()),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child:
                SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ),
          ],
        ),
        SizedBox(
          height: isMobile(context) ? 230.h : 260.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Get.toNamed(Routes.shopScreen,
                    parameters: {'shopId': (items[index].id ?? 0).toString()}),
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: ShopCardWidget(shop: items[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //Express Shop
  Widget expressShop(expressShopIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![expressShopIndex].expressShops;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(AppTags.expressShop.tr,
                  style: isMobile(context)
                      ? AppThemeData.headerTextStyle
                      : AppThemeData.headerTextStyleTab),
            ),
            InkWell(
              onTap: () => Get.to(() => const AllShop()),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child:
                SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ),
          ],
        ),
        SizedBox(
          height: isMobile(context) ? 230.h : 260.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Get.toNamed(Routes.shopScreen,
                    parameters: {'shopId': (items[index].id ?? 0).toString()}),
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: ShopCardWidget(shop: items[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Best Shop
  Widget bestShop(bestShopIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![bestShopIndex].bestShops;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(AppTags.bestShop.tr,
                  style: isMobile(context)
                      ? AppThemeData.headerTextStyle
                      : AppThemeData.headerTextStyleTab),
            ),
            InkWell(
              onTap: () => Get.to(() => const BestShop()),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child:
                SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ),
          ],
        ),
        SizedBox(
          height: isMobile(context) ? 230.h : 260.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Get.toNamed(Routes.shopScreen,
                    parameters: {'shopId': (items[index].id ?? 0).toString()}),
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: ShopCardWidget(shop: items[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //Top Shop
  Widget topShop(sellersIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![sellersIndex].topShops;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(AppTags.topShop.tr,
                  style: isMobile(context)
                      ? AppThemeData.headerTextStyle
                      : AppThemeData.headerTextStyleTab),
            ),
            InkWell(
              onTap: () => Get.to(() => const TopShop()),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child:
                SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ),
          ],
        ),
        SizedBox(
          height: isMobile(context) ? 230.h : 260.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Get.toNamed(Routes.shopScreen,
                    parameters: {'shopId': (items[index].id ?? 0).toString()}),
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: ShopCardWidget(shop: items[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //Latest News
  Widget latestNews(latestNewsIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![latestNewsIndex].latestNews;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        InkWell(
          onTap: () => Get.to(AllNews()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(AppTags.latestNews.tr,
                    style: isMobile(context)
                        ? AppThemeData.headerTextStyle
                        : AppThemeData.headerTextStyleTab),
              ),
              Padding(
                padding: EdgeInsets.all(15.r),
                child: SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                onTap: () {
                  Get.toNamed(Routes.newsScreen, parameters: {
                    'title': item.title ?? '',
                    'url': item.url ?? '',
                    'image': item.thumbnail ?? '',
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 200.h,
                        width: isMobile(context) ? 165.w : 130.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.all(Radius.circular(7.r)),
                          boxShadow: [
                            BoxShadow(
                              color: AppThemeData.boxShadowColor
                                  .withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 10.r,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: item.thumbnail != null
                                      ? DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          item.thumbnail!))
                                      : null,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 4.w, bottom: 4.h, top: 4.h),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title ?? '',
                                      style: isMobile(context)
                                          ? AppThemeData.titleTextStyle_14
                                          : AppThemeData
                                          .titleTextStyle_11Tab,
                                      maxLines: 1,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      item.shortDescription ?? '',
                                      style: isMobile(context)
                                          ? AppThemeData.qsTextStyle_12
                                          : AppThemeData.qsTextStyle_9Tab,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
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
          ),
        ),
      ],
    );
  }

  //Today Deal
  Widget todayDeal(todayDealIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![todayDealIndex].todayDeals;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    String time = "24:00:00";
    String date = "$formattedDate $time";

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Text(AppTags.todayDeal.tr,
                      style: isMobile(context)
                          ? AppThemeData.headerTextStyle
                          : AppThemeData.headerTextStyleTab),
                ),
                SizedBox(width: 10.w),
                CountdownTimer(
                  endTime: DateTime.now().millisecondsSinceEpoch +
                      DateTime.parse(date)
                          .difference(DateTime.now())
                          .inMilliseconds,
                  widgetBuilder: (_, time) {
                    if (time == null) {
                      return Center(
                        child: Text('Over',
                            style: isMobile(context)
                                ? AppThemeData.timeDateTextStyle_12
                                : AppThemeData.timeDateTextStyleTab),
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _timeBox("${time.hours ?? 0}".padLeft(2, '0'),
                            context),
                        SizedBox(width: 5.w),
                        _timeBox(
                            "${time.min ?? 0}".padLeft(2, '0'), context),
                        SizedBox(width: 5.w),
                        _timeBox(
                            "${time.sec ?? 0}".padLeft(2, '0'), context),
                      ],
                    );
                  },
                ),
              ],
            ),
            InkWell(
              onTap: () => Get.to(() => const TodayDeal()),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child:
                SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile(context) ? 0.h : 8.h),
        SizedBox(
          height: 255.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: HomeProductCard(
                  dataModel: items,
                  index: index,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _timeBox(String value, context) {
    return Container(
      width: isMobile(context) ? 30.w : 20.w,
      height: isMobile(context) ? 20.h : 23.h,
      decoration: BoxDecoration(
        color: const Color(0xff333333),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Center(
        child: Text(value,
            style: isMobile(context)
                ? AppThemeData.timeDateTextStyle_12
                : AppThemeData.timeDateTextStyleTab),
      ),
    );
  }

  //Offer Ending
  Widget offerEnding(offerEndingIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![offerEndingIndex].offerEnding;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(AppTags.offerEnding.tr,
                  style: isMobile(context)
                      ? AppThemeData.headerTextStyle
                      : AppThemeData.headerTextStyleTab),
            ),
            InkWell(
              onTap: () => Get.to(() => const OfferEndingProductsView()),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child:
                SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 255.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: HomeProductCard(dataModel: items, index: index),
              );
            },
          ),
        ),
      ],
    );
  }

  //Flash Sale
  Widget flashSale(flashProductsIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![flashProductsIndex].flashDeals;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(AppTags.flashSale.tr,
                  style: isMobile(context)
                      ? AppThemeData.headerTextStyle
                      : AppThemeData.headerTextStyleTab),
            ),
            InkWell(
              onTap: () => Get.to(() => const FlashSales()),
              child: Padding(
                padding: EdgeInsets.all(15.0.r),
                child:
                SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        SizedBox(
          height: 255.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: HomeProductCard(dataModel: items, index: index),
              );
            },
          ),
        ),
      ],
    );
  }

  // ✅ Recent Product — affiche les produits récemment consultés (stockage local)
  Widget recentViewProducts(int index, BuildContext context) {
    final products = homeScreenContentController.localRecentProducts;

    if (products.isEmpty) {
      return const SizedBox();
    }

    return Container(
      height: 260,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "Produits récents",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,

              itemBuilder: (context, i) {
                final product = products[i];

                return GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.detailsPage,
                        parameters: {'productId': product['id'].toString()});
                  },
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.symmetric(horizontal: 8),

                    child: Card(
                      elevation: 3,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Expanded(
                            child: Image.network(
                              product['image'] ?? "",
                              width: double.infinity,
                              fit: BoxFit.cover,

                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image, size: 50),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              product['title'] ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              Get.find<CurrencyConverterController>()
                                  .convertCurrency(product['price'] ?? "0"),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  // ✅ Custom Products — corrigé avec guard null propre
  Widget customProducts(index, context) {
    final section =
    homeScreenContentController.homeDataModel.value.data![index];
    final products = section.customProducts;

    if (products == null || products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(15.w, 16.h, 15.w, 8.h),
          child: Text(
            "Produits",
            style: isMobile(context)
                ? AppThemeData.headerTextStyle
                : AppThemeData.headerTextStyleTab,
          ),
        ),
        SizedBox(
          height: 255.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: HomeProductCard(
                  dataModel: products,
                  index: i,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  //Latest Product
  Widget latestProducts(latestProductsIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![latestProductsIndex].latestProducts;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(AppTags.latestProducts.tr,
                  style: isMobile(context)
                      ? AppThemeData.headerTextStyle
                      : AppThemeData.headerTextStyleTab),
            ),
            InkWell(
              onTap: () => Get.to(() => const AllProductView()),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child: SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        SizedBox(
          height: 255.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: HomeProductCard(dataModel: items, index: index),
              );
            },
          ),
        ),
      ],
    );
  }

  //Best Selling Product
  Widget bestSellingProduct(bestSellingProductIndex, context) {
    final items = homeScreenContentController.homeDataModel.value
        .data![bestSellingProductIndex].bestSellingProducts;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(AppTags.bestSellingProducts.tr,
                  style: isMobile(context)
                      ? AppThemeData.headerTextStyle
                      : AppThemeData.headerTextStyleTab),
            ),
            InkWell(
              onTap: () => Get.to(() => const BestSellingProductsView()),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child: SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        SizedBox(
          height: 255.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: HomeProductCard(dataModel: items, index: index),
              );
            },
          ),
        ),
      ],
    );
  }

  //Video Shopping
  Widget videoShopping(videoShoppingIndex, context) {
    final items = homeScreenContentController
        .homeDataModel.value.data![videoShoppingIndex].videoShopping;
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(AppTags.videoShopping.tr,
                  style: isMobile(context)
                      ? AppThemeData.headerTextStyle
                      : AppThemeData.headerTextStyleTab),
            ),
            InkWell(
              onTap: () => Get.to(() => const AllVideoShopping()),
              child: Padding(
                padding: EdgeInsets.all(15.r),
                child: SvgPicture.asset(Images.more, height: 4.h, width: 18.w),
              ),
            ),
          ],
        ),
        SizedBox(
          height: isMobile(context) ? 150.h : 220.h,
          child: ListView.builder(
            padding: EdgeInsets.only(right: 15.w),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                onTap: () => Get.toNamed(Routes.detailsVideoShopping,
                    parameters: {'videoSlug': item.slug.toString()}),
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: SizedBox(
                    width: 105.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            image: item.thumbnail != null
                                ? DecorationImage(
                                image: NetworkImage(item.thumbnail!),
                                fit: BoxFit.cover)
                                : null,
                          ),
                        ),
                        isMobile(context)
                            ? SvgPicture.asset(Images.playVideo)
                            : SvgPicture.asset(Images.playVideo, height: 35.h),
                        Positioned(
                          top: 5.h,
                          left: 10.w,
                          child: Text(
                            item.isLive == true ? "LIVE" : "",
                            style: isMobile(context)
                                ? AppThemeData.todayDealNewStyle
                                : AppThemeData.todayDealNewStyleTab,
                          ),
                        ),
                        Positioned(
                          bottom: 5.h,
                          left: 3.w,
                          right: 3.w,
                          child: Text(
                            item.title.toString(),
                            style: isMobile(context)
                                ? AppThemeData.timeDateTextStyle_12
                                : AppThemeData.timeDateTextStyleTab,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget categoryCheck(HomeDataModel data, index, context) {
    final sectionType = data.data![index].sectionType ?? '';

    switch (sectionType) {
      case "categories":
        return _categories(index, context);
      case 'slider':
        return slider(index, context);
      case 'benefits':
        return const SizedBox.shrink();
      case 'popular_categories':
        return popularCategories(index, context);
      case 'banners':
        return banner(index, context);
      case 'campaigns':
        return campaign(index, context);
      case 'top_categories':
        return topCategories(index, context);
      case 'today_deals':
        return todayDeal(index, context);
      case 'flash_deals':
        return flashSale(index, context);
      case 'category_sec_banner':
        return const SizedBox.shrink();
      case 'category_sec_banner_url':
        return const SizedBox.shrink();
      case 'category_section':
        return const SizedBox.shrink();
      case 'best_selling_products':
        return bestSellingProduct(index, context);
      case 'offer_ending':
        return offerEnding(index, context);
      case 'offer_ending_banner':
        return const SizedBox.shrink();
      case 'offer_ending_banner_url':
        return const SizedBox.shrink();
      case 'latest_products':
        return latestProducts(index, context);
      case 'latest_news':
        return latestNews(index, context);
      case 'popular_brands':
        return popularBrands(index, context);
      case 'best_shops':
        return bestShop(index, context);
      case 'top_shops':
        return topShop(index, context);
      case 'featured_shops':
        return featuredShop(index, context);
      case 'express_shops':
        return expressShop(index, context);
      case 'recent_viewed_product':
        return recentViewProducts(index, context);
      case 'custom_products':
        return customProducts(index, context);
      case 'products':
        return customProducts(index, context);
      case 'subscription_section':
        return const SizedBox.shrink();
      case 'video_shopping':
        return videoShopping(index, context);
      default:
        print("⚠️ Section non gérée: '$sectionType'");
        return const SizedBox.shrink();
    }
  }
}

class RecentViewProductScreen {
  const RecentViewProductScreen();
}