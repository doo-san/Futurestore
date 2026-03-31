class CouponAppliedList {
  CouponAppliedList({
    this.success,
    this.message,
    this.data,
  });

  /// 🔒 MODELE VIDE
  factory CouponAppliedList.empty() {
    return CouponAppliedList(
      success: true,
      message: "",
      data: [],
    );
  }

  CouponAppliedList.fromJson(dynamic json) {

    /// 🔒 Protection JSON null
    if (json == null || json is! Map<String, dynamic>) {
      success = false;
      message = "";
      data = [];
      return;
    }

    success = json['success'] ?? false;
    message = json['message'] ?? "";

    /// 🔒 Protection data
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((v) => Data.fromJson(v))
          .toList();
    } else {
      data = [];
    }
  }

  bool? success;
  String? message;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['data'] = data?.map((v) => v.toJson()).toList() ?? [];
    return map;
  }
}

class Data {
  Data({
    this.couponId,
    this.title,
    this.status,
    this.discountType,
    this.discount,
    this.couponDiscount,
  });

  Data.fromJson(dynamic json) {

    /// 🔒 Protection JSON null
    if (json == null || json is! Map<String, dynamic>) {
      return;
    }

    couponId = json['coupon_id'] ?? 0;
    title = json['title'] ?? "";
    status = json['status'] ?? 0;
    discountType = json['discount_type'] ?? "";
    discount = json['discount'];
    couponDiscount = json['coupon_discount'] ?? 0;
  }

  int? couponId;
  String? title;
  int? status;
  String? discountType;
  dynamic discount;
  int? couponDiscount;

  Map<String, dynamic> toJson() {
    return {
      'coupon_id': couponId,
      'title': title,
      'status': status,
      'discount_type': discountType,
      'discount': discount,
      'coupon_discount': couponDiscount,
    };
  }
}