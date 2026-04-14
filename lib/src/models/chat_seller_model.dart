class ChatSellerModel {
  ChatSellerModel({required this.success, required this.sellers});
  late final bool success;
  late final List<ChatSeller> sellers;

  ChatSellerModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    // data.data (paginated collection inside data wrapper)
    final outer = json['data'];
    List<dynamic>? raw;
    if (outer is Map<String, dynamic>) {
      final inner = outer['data'];
      raw = inner is List ? inner : null;
    } else if (outer is List) {
      raw = outer;
    }
    sellers = raw?.map((e) => ChatSeller.fromJson(e as Map<String, dynamic>)).toList() ?? [];
  }
}

class ChatSeller {
  ChatSeller({
    required this.userId,
    required this.shopName,
    required this.logo,
    required this.lastMessage,
    required this.chatRoomId,
  });
  late final int userId;      // seller's user_id — used as receiver_id when sending
  late final String shopName;
  late final String logo;
  late final String lastMessage;
  late final int chatRoomId;  // 0 if no conversation yet

  ChatSeller.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ?? 0;
    shopName = json['shop_name']?.toString() ?? json['user_name']?.toString() ?? '';
    logo = json['logo']?.toString() ?? '';
    chatRoomId = int.tryParse(json['chat_room_id']?.toString() ?? '0') ?? 0;
    // message can be "" or {"message": "..."}
    final msg = json['message'];
    if (msg is Map<String, dynamic>) {
      lastMessage = msg['message']?.toString() ?? '';
    } else {
      lastMessage = '';
    }
  }
}
