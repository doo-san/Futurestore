import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../controllers/all_notifications_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../models/all_notifications.dart';
import '../../servers/repository.dart';
import '../../utils/app_tags.dart';
import '../../utils/app_theme_data.dart';
import '../../utils/responsive.dart';
import '../../widgets/network_image_checker.dart';
import '../../widgets/notification_widget.dart';
import '../../_route/routes.dart';

class NotificationsMessagesScreen extends StatefulWidget {
  const NotificationsMessagesScreen({super.key});

  @override
  State<NotificationsMessagesScreen> createState() =>
      _NotificationsMessagesScreenState();
}

class _NotificationsMessagesScreenState
    extends State<NotificationsMessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Controllers are registered by NotificationsMessagesBinding via the route.
    final notifController = Get.find<AllNotificationsController>();
    final chatController = Get.find<ChatController>();

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
          '${AppTags.notification.tr} & ${AppTags.messages.tr}',
          style: isMobile(context)
              ? AppThemeData.headerTextStyle_16.copyWith(color: Colors.white)
              : AppThemeData.headerTextStyle_14.copyWith(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: isMobile(context) ? 14.sp : 11.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: isMobile(context) ? 14.sp : 11.sp,
            fontWeight: FontWeight.normal,
          ),
          tabs: [
            Tab(text: AppTags.notification.tr),
            Tab(text: AppTags.messages.tr),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _NotificationsTab(controller: notifController),
          _MessagesTab(controller: chatController),
        ],
      ),
    );
  }
}

// ─── Onglet Notifications ────────────────────────────────────────────────────

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

  /// Shimmer inline — pas de Scaffold imbriqué.
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

// ─── Onglet Messages ─────────────────────────────────────────────────────────

class _MessagesTab extends StatelessWidget {
  final ChatController controller;
  const _MessagesTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.sellersLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.sellersError.value) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              SizedBox(height: 12.h),
              Text('Erreur de chargement',
                  style: AppThemeData.titleTextStyle_13),
              SizedBox(height: 12.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemeData.productBoxDecorationColor),
                onPressed: controller.fetchSellers,
                child: const Text('Réessayer',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }
      if (controller.sellers.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat_bubble_outline,
                  size: 64.r, color: Colors.grey.shade300),
              SizedBox(height: 16.h),
              Text(
                'Aucune conversation',
                style: AppThemeData.titleTextStyle_13
                    .copyWith(color: Colors.grey),
              ),
            ],
          ),
        );
      }
      return RefreshIndicator(
        color: AppThemeData.productBoxDecorationColor,
        onRefresh: controller.fetchSellers,
        child: ListView.separated(
          itemCount: controller.sellers.length,
          separatorBuilder: (context2, i) =>
              Divider(height: 1, color: Colors.grey.shade200),
          itemBuilder: (context, index) {
            final seller = controller.sellers[index];
            return ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: SizedBox(
                  width: 48.r,
                  height: 48.r,
                  child: NetworkImageCheckerWidget(
                    image: seller.logo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                seller.shopName,
                style: AppThemeData.titleTextStyle_14,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: seller.lastMessage.isNotEmpty
                  ? Text(
                      seller.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppThemeData.titleTextStyle_13
                          .copyWith(color: Colors.grey),
                    )
                  : null,
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () async {
                await controller.openChatRoom(
                    seller.chatRoomId, seller.userId, seller.shopName);
                Get.toNamed(Routes.chatRoom);
              },
            );
          },
        ),
      );
    });
  }
}
