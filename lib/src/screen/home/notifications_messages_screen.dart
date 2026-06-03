import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../controllers/all_notifications_controller.dart';
import '../../models/all_notifications.dart';
import '../../servers/repository.dart';
import '../../utils/app_tags.dart';
import '../../utils/app_theme_data.dart';
import '../../utils/responsive.dart';
import '../../widgets/notification_widget.dart';

class NotificationsMessagesScreen extends StatelessWidget {
  const NotificationsMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifController = Get.find<AllNotificationsController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF0008),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,
              size: isMobile(context) ? 24 : 22.r),
          onPressed: Get.back,
        ),
        centerTitle: true,
        title: Text(
          AppTags.notification.tr,
          style: isMobile(context)
              ? AppThemeData.headerTextStyle_16.copyWith(color: Colors.white)
              : AppThemeData.headerTextStyle_14.copyWith(color: Colors.white),
        ),
      ),
      body: _NotificationsTab(controller: notifController),
    );
  }
}

class _NotificationsTab extends StatelessWidget {
  final AllNotificationsController controller;
  const _NotificationsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.noData.value) return _noDataWidget(context);
      if (!controller.dataAvailable) return _shimmer();
      return Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: ListView(
              shrinkWrap: true,
              controller: controller.scrollController,
              physics: const BouncingScrollPhysics(),
              children: [
                controller.allNotifications.isNotEmpty
                    ? _notifList(context, controller.allNotifications)
                    : const SizedBox(),
              ],
            ),
          ),
          Positioned(
            bottom: 25.h,
            child: controller.isMoreDataLoading.value
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox(),
          ),
        ],
      );
    });
  }

  Widget _noDataWidget(BuildContext context) {
    return Center(
      child: Text(
        AppTags.noNotification.tr,
        style: TextStyle(
          fontSize: isMobile(context) ? 14.sp : 11.sp,
          color: const Color(0xFF666666),
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _shimmer() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade300,
          child: Container(
            height: 70.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _notifList(BuildContext context, List<Notifications> notifications) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppTags.allNotifications.tr,
              style: TextStyle(
                fontSize: isMobile(context) ? 14.sp : 11.sp,
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
            ),
            TextButton(
              onPressed: () => _deleteAll(context),
              child: Text(
                AppTags.clearAll.tr,
                style: TextStyle(
                  fontSize: isMobile(context) ? 12.sp : 9.sp,
                  color: const Color(0xFF999999),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Slidable(
              key: ValueKey(notifications[index].id),
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {
                  _deleteOne(notifications[index].id, context);
                }),
                children: [
                  SlidableAction(
                    onPressed: (_) =>
                        controller.removeNotification(notifications[index].id),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: AppTags.delete.tr,
                  ),
                ],
              ),
              child: NotificationWidget(
                notification: notifications[index],
                isOtherNotification: true,
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _deleteOne(int id, BuildContext context) async {
    final isDeleted = await Repository().deleteNotification(id);
    if (!context.mounted) return;
    if (isDeleted != null) {
      isDeleted
          ? _snack(context, AppTags.notificationDeleted.tr)
          : _snack(context, AppTags.notificationCanNotBeDeleted.tr);
    } else {
      _snack(context, AppTags.somethingWentWrong.tr);
    }
  }

  void _deleteAll(BuildContext context) {
    controller.deleteAllNotifications().then((value) {
      if (!context.mounted) return;
      value
          ? _snack(context, AppTags.allNotificationsDeleted.tr)
          : _snack(context, AppTags.notificationCanNotBeDeleted.tr);
    });
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
