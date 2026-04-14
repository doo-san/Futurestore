class AllNotifications {
  AllNotifications({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final Data data;

  AllNotifications.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message']?.toString() ?? "";
    data = json['data'] != null
        ? Data.fromJson(json['data'])
        : Data(notifications: []);
  }

  Map<String, dynamic> toJson() {
    final jsonData = <String, dynamic>{};
    jsonData['success'] = success;
    jsonData['message'] = message;
    jsonData['data'] = data.toJson();
    return jsonData;
  }
}

class Data {
  Data({
    required this.notifications,
  });
  late final List<Notifications> notifications;

  Data.fromJson(Map<String, dynamic> json) {
    notifications = json['notifications'] != null
        ? List.from(json['notifications'])
            .map((e) => Notifications.fromJson(e))
            .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['notifications'] = notifications.map((e) => e.toJson()).toList();
    return data;
  }
}

class Notifications {
  Notifications({
    required this.id,
    required this.title,
    required this.userId,
    required this.url,
    required this.status,
    required this.details,
    required this.createdAt,
  });
  late final int id;
  late final String title;
  late final int userId;
  late final String url;
  late final String status;
  late final String details;
  late final DateTime createdAt;

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    title = json['title']?.toString() ?? "";
    userId = json['user_id'] ?? 0;
    url = json['url']?.toString() ?? "";
    status = json['status']?.toString() ?? "";
    details = json['details']?.toString() ?? "";
    createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
        : DateTime.now();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['user_id'] = userId;
    data['url'] = url;
    data['status'] = status;
    data['details'] = details;
    data['created_at'] = createdAt;
    return data;
  }
}
