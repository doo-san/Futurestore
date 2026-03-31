import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../_route/routes.dart';
import '../utils/app_theme_data.dart';
import '../utils/responsive.dart';


class ShopCardWidget extends StatelessWidget {
  final dynamic shop;
  const ShopCardWidget({super.key, this.shop});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.shopScreen,
          parameters: {
            'shopId': shop.id.toString(),
          },
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: isMobile(context)? 200.h : 230.h,
            width: isMobile(context)?165.w:120.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(7.r)),
              boxShadow: [
                BoxShadow(
                  color: AppThemeData.boxShadowColor.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10.r,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: shop.banner.toString(),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.store_outlined, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.w, bottom: 4.h, top: 4.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 35.h,
                        ),
                        RatingBarIndicator(
                          rating: double.parse(
                            shop.rating!.toString(),
                          ),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 18.r,
                          direction: Axis.horizontal,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          shop.shopName!,
                          style: isMobile(context)? AppThemeData.titleTextStyle_14.copyWith(fontSize: 13.sp):AppThemeData.titleTextStyle_11Tab,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: isMobile(context)? 55.w:42.w,
            child: Container(
              height: 55.h,
              width: isMobile(context)?55.w:38.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(35.r)),
                boxShadow: [
                  BoxShadow(
                    color: AppThemeData.boxShadowColor.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 6,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: shop.logo!.toString(),
                  height: 60.h,
                  width: isMobile(context) ? 60.w : 38.w,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.store, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
