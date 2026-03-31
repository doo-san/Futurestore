int safeInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is String) {
    return int.tryParse(value) ?? 0;
  }

  if (value is double) {
    return value.toInt();
  }

  return 0;
}

double safeDouble(dynamic value) {
  if (value == null) return 0;

  if (value is double) return value;

  if (value is int) return value.toDouble();

  if (value is String) {
    return double.tryParse(value) ?? 0;
  }

  return 0;
}

bool safeBool(dynamic value) {
  if (value == null) return false;

  if (value is bool) return value;

  if (value is int) return value == 1;

  if (value is String) {
    return value.toLowerCase() == "true" || value == "1";
  }

  return false;
}

String safeString(dynamic value) {
  if (value == null) return "";
  return value.toString();
}

List safeList(dynamic value) {
  if (value == null) return [];

  if (value is List) return value;

  return [];
}