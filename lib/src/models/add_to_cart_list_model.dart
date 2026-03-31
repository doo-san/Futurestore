class AddToCartListModel {
  AddToCartListModel({
    this.success,
    this.message,
    this.data,
  });

  factory AddToCartListModel.empty() {
    return AddToCartListModel(
      success: true,
      message: "",
      data: AddToCartListModelData(
        carts: [],
        trxId: "",
        calculations: Calculations(),
      ),
    );
  }

  AddToCartListModel.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      success = false;
      message = "";
      data = null;
      return;
    }

    success = json['success'] ?? false;
    message = json['message'] ?? "";

    data = (json['data'] != null && json['data'] is Map<String, dynamic>)
        ? AddToCartListModelData.fromJson(json['data'])
        : null;
  }

  bool? success;
  String? message;
  AddToCartListModelData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class AddToCartListModelData {
  AddToCartListModelData({
    this.carts,
    this.trxId,
    this.calculations,
  });

  AddToCartListModelData.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      carts = [];
      trxId = "";
      calculations = null;
      return;
    }

    if (json['carts'] != null && json['carts'] is List) {
      carts = (json['carts'] as List)
          .map((v) => Carts.fromJson(v))
          .toList();
    } else {
      carts = [];
    }

    trxId = json['trx_id'] ?? "";

    calculations = (json['calculations'] != null &&
        json['calculations'] is Map<String, dynamic>)
        ? Calculations.fromJson(json['calculations'])
        : null;
  }

  List<Carts>? carts;
  String? trxId;
  Calculations? calculations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['carts'] = carts?.map((v) => v.toJson()).toList() ?? [];
    map['trx_id'] = trxId;
    if (calculations != null) {
      map['calculations'] = calculations!.toJson();
    }
    return map;
  }

}

class Calculations {
  Calculations({
    this.subTotal,
    this.formattedSubTotal,
    this.discount,
    this.formattedDiscount,
    this.shippingCost,
    this.formattedShippingCost,
    this.tax,
    this.formattedTax,
    this.couponDiscount,
    this.formattedCouponDiscount,
    this.total,
    this.formattedTotal,
  });

  Calculations.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return;
    }

    subTotal = json['sub_total'];
    formattedSubTotal = json['formatted_sub_total'] ?? "0";
    discount = json['discount'];
    formattedDiscount = json['formatted_discount'] ?? "0";
    shippingCost = json['shipping_cost']?.toString();
    formattedShippingCost = json['formatted_shipping_cost'] ?? "0";
    tax = json['tax']?.toString();
    formattedTax = json['formatted_tax'] ?? "0";
    couponDiscount = json['coupon_discount']?.toString();
    formattedCouponDiscount =
        json['formatted_coupon_discount'] ?? "0";
    total = json['total'];
    formattedTotal = json['formatted_total'] ?? "0";
  }

  dynamic subTotal;
  String? formattedSubTotal;
  dynamic discount;
  String? formattedDiscount;
  String? shippingCost;
  String? formattedShippingCost;
  String? tax;
  String? formattedTax;
  String? couponDiscount;
  String? formattedCouponDiscount;
  dynamic total;
  String? formattedTotal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sub_total'] = subTotal;
    map['formatted_sub_total'] = formattedSubTotal;
    map['discount'] = discount;
    map['formatted_discount'] = formattedDiscount;
    map['shipping_cost'] = shippingCost;
    map['formatted_shipping_cost'] = formattedShippingCost;
    map['tax'] = tax;
    map['formatted_tax'] = formattedTax;
    map['coupon_discount'] = couponDiscount;
    map['formatted_coupon_discount'] = formattedCouponDiscount;
    map['total'] = total;
    map['formatted_total'] = formattedTotal;
    return map;
  }
}

class Carts {
  Carts({
    this.id,
    this.sellerId,
    this.productId,
    this.productName,
    this.productImage,
    this.shopName,
    this.shopImage,
    this.variant,
    this.quantity,
    this.price,
    this.formattedPrice,
    this.discount,
    this.subTotal,
    this.formattedDiscount,
    this.formattedSubTotal,
    this.minimumOrder,
    this.stock,
  });

  Carts.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) return;

    id = json['id'] ?? 0;
    sellerId = json['seller_id'] ?? 0;
    productId = json['product_id'] ?? 0;
    productName = json['product_name'] ?? "";
    productImage = json['product_image'] ?? "";
    shopName = json['shop_name'] ?? "";
    shopImage = json['shop_image'] ?? "";
    variant = json['variant'] ?? "";
    quantity = json['quantity'] ?? 0;
    price = json['price'];
    formattedPrice = json['formatted_price'] ?? "";
    discount = json['discount'] ?? 0;
    subTotal = json['sub_total'];
    minimumOrder = json['minimum_order_quantity'] ?? 0;
    stock = json['stock'] ?? 0;
    formattedDiscount = json['formatted_discount'] ?? "";
    formattedSubTotal = json['formatted_sub_total'] ?? "";
  }

  int? id;
  int? sellerId;
  int? productId;
  String? productName;
  String? productImage;
  String? shopName;
  String? shopImage;
  String? variant;
  int? quantity;
  dynamic price;
  String? formattedPrice;
  dynamic discount;
  dynamic subTotal;
  String? formattedDiscount;
  String? formattedSubTotal;
  int? minimumOrder;
  int? stock;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller_id': sellerId,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'shop_name': shopName,
      'shop_image': shopImage,
      'variant': variant,
      'quantity': quantity,
      'price': price,
      'formatted_price': formattedPrice,
      'discount': discount,
      'sub_total': subTotal,
      'formatted_discount': formattedDiscount,
      'formatted_sub_total': formattedSubTotal,
      'minimum_order_quantity': minimumOrder,
      'stock': stock,
    };
  }
}