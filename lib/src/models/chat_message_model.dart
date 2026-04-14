class ChatMessageModel {
  ChatMessageModel({required this.messages});
  late final List<ChatMessage> messages;

  // Response structure:
  // { success: false, data: { messages: { data: [...] } } }
  // Note: the backend uses responseWithError even on success (bug), so
  // success can be false even when data is valid.
  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final outer = json['data'];
    List<dynamic>? raw;
    if (outer is Map<String, dynamic>) {
      final msgWrapper = outer['messages'];
      if (msgWrapper is Map<String, dynamic>) {
        final inner = msgWrapper['data'];
        raw = inner is List ? inner : null;
      } else if (msgWrapper is List) {
        raw = msgWrapper;
      }
    }
    messages = raw?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>)).toList() ?? [];
  }
}

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.message,
    required this.type,
    required this.createdAt,
  });
  late final int id;
  late final String message;
  late final int type;          // 1 = customer sent, 2 = seller sent
  late final DateTime createdAt;
  String? image;

  // type == 1 means the customer (current user) sent it
  bool get isFromMe => type == 1;

  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    message = json['message']?.toString() ?? '';
    type = json['type'] ?? 1;
    createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
        : DateTime.now();
  }
}
