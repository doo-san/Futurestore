import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller.dart';
import '../../_route/routes.dart';
import '../../utils/app_theme_data.dart';
import '../../widgets/network_image_checker.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppThemeData.productBoxDecorationColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: Get.back,
        ),
        centerTitle: true,
        title: Text(
          'Mes messages',
          style: AppThemeData.headerTextStyle_16.copyWith(color: Colors.white),
        ),
      ),
      body: Obx(() {
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
                Text('Erreur de chargement', style: AppThemeData.titleTextStyle_13),
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
            separatorBuilder: (_, __) =>
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
      }),
    );
  }
}
