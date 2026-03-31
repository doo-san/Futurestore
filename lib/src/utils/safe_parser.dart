class SafeParser {
  /// 🔒 Toujours retourne un Map<String, dynamic>
  static Map<String, dynamic> asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;

    if (value is Map) {
      return value.map(
            (key, val) => MapEntry(key.toString(), val),
      );
    }

    return {};
  }

  /// 🔒 Toujours retourne une List<Map<String, dynamic>>
  static List<Map<String, dynamic>> asListOfMap(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((e) => asMap(e))
          .toList();
    }
    return [];
  }

  /// 🔒 Toujours retourne une List
  static List asList(dynamic value) {
    if (value is List) return value;
    return [];
  }

  /// 🔒 String sécurisé
  static String asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  /// 🔒 Int sécurisé
  static int asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is bool) return value ? 1 : 0;
    return 0;
  }

  /// 🔒 Double sécurisé
  static double asDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// 🔒 Bool sécurisé (gère int et string)
  static bool asBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }
}