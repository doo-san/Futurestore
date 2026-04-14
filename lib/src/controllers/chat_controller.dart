import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/chat_message_model.dart';
import '../models/chat_seller_model.dart';
import '../servers/repository.dart';
import '../utils/constants.dart';

class ChatController extends GetxController {
  // Seller list
  final sellers = <ChatSeller>[].obs;
  final sellersLoading = true.obs;
  final sellersError = false.obs;

  // Current room
  final messages = <ChatMessage>[].obs;
  final messagesLoading = false.obs;
  int currentChatRoomId = 0;
  int currentReceiverId = 0;   // seller's user_id
  String currentShopName = '';

  final TextEditingController messageInput = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSellers();
  }

  Future<void> fetchSellers() async {
    sellersLoading(true);
    sellersError(false);
    try {
      final result = await Repository().getChatSellers();
      if (result != null && result.success) {
        sellers.assignAll(result.sellers);
      } else {
        sellersError(true);
      }
    } catch (e) {
      printLog('fetchSellers error: $e');
      sellersError(true);
    } finally {
      sellersLoading(false);
    }
  }

  Future<void> openChatRoom(int chatRoomId, int receiverId, String shopName) async {
    currentChatRoomId = chatRoomId;
    currentReceiverId = receiverId;
    currentShopName = shopName;
    messages.clear();
    messagesLoading(true);
    try {
      if (chatRoomId > 0) {
        final result = await Repository().getChatMessages(chatRoomId: chatRoomId);
        if (result != null) {
          messages.assignAll(result.messages);
          _scrollToBottom();
        }
      }
    } catch (e) {
      printLog('openChatRoom error: $e');
    } finally {
      messagesLoading(false);
    }
  }

  Future<void> sendMessage() async {
    final text = messageInput.text.trim();
    if (text.isEmpty || isSending.value) return;
    isSending(true);
    final optimistic = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch,
      message: text,
      type: 1, // customer sent
      createdAt: DateTime.now(),
    );
    messages.add(optimistic);
    messageInput.clear();
    _scrollToBottom();
    try {
      final ok = await Repository().sendChatMessage(
        receiverId: currentReceiverId,
        message: text,
        chatRoomId: currentChatRoomId > 0 ? currentChatRoomId : null,
      );
      if (!ok) {
        messages.remove(optimistic);
        Get.snackbar('Erreur', 'Impossible d\'envoyer le message',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      messages.remove(optimistic);
      printLog('sendMessage error: $e');
    } finally {
      isSending(false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageInput.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
