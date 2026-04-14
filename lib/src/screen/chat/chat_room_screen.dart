import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/chat_controller.dart';
import '../../utils/app_theme_data.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppThemeData.productBoxDecorationColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: Get.back,
        ),
        title: Text(
          controller.currentShopName,
          style: AppThemeData.headerTextStyle_16.copyWith(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messagesLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.messages.isEmpty) {
                return Center(
                  child: Text(
                    'Aucun message. Commencez la conversation !',
                    style: AppThemeData.titleTextStyle_13
                        .copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return ListView.builder(
                controller: controller.scrollController,
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return _MessageBubble(
                    message: msg.message,
                    isFromMe: msg.isFromMe,
                    time: DateFormat('HH:mm').format(msg.createdAt),
                  );
                },
              );
            }),
          ),
          _InputBar(controller: controller),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isFromMe,
    required this.time,
  });
  final String message;
  final bool isFromMe;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 4.h,
          bottom: 4.h,
          left: isFromMe ? 60.w : 0,
          right: isFromMe ? 0 : 60.w,
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isFromMe
              ? AppThemeData.productBoxDecorationColor
              : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft:
                isFromMe ? Radius.circular(16.r) : Radius.circular(4.r),
            bottomRight:
                isFromMe ? Radius.circular(4.r) : Radius.circular(16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isFromMe ? Colors.white : Colors.black87,
                fontSize: 14.sp,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              time,
              style: TextStyle(
                color: isFromMe
                    ? Colors.white.withValues(alpha: 0.75)
                    : Colors.grey,
                fontSize: 10.sp,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller});
  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 8.h + MediaQuery.of(context).padding.bottom),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageInput,
              minLines: 1,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Écrire un message...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => controller.sendMessage(),
            ),
          ),
          SizedBox(width: 8.w),
          Obx(() => GestureDetector(
                onTap: controller.isSending.value ? null : controller.sendMessage,
                child: Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: AppThemeData.productBoxDecorationColor,
                    shape: BoxShape.circle,
                  ),
                  child: controller.isSending.value
                      ? Padding(
                          padding: EdgeInsets.all(10.r),
                          child: const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Icon(Icons.send, color: Colors.white, size: 20.r),
                ),
              )),
        ],
      ),
    );
  }
}
