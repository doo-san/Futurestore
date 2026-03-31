class ProductByCategoryModel {

  bool success;
  String message;
  List<CategoryProductData> data;

  ProductByCategoryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductByCategoryModel.fromJson(Map<String, dynamic>? json) {

    if (json == null) {
      return ProductByCategoryModel(
        success: false,
        message: "",
        data: [],
      );
    }

    return ProductByCategoryModel(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? "",
      data: json['data'] != null
          ? List<CategoryProductData>.from(
        json['data'].map(
              (x) => CategoryProductData.fromJson(x),
        ),
      )
          : [],
    );

  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "data": data.map((x) => x.toJson()).toList(),
    };
  }

}



class CategoryProductData {

  int id;
  String slug;
  String title;
  String shortDescription;
  String specialDiscountType;
  double specialDiscount;
  double discountPrice;
  String image;
  double price;
  double rating;
  int totalReviews;
  int currentStock;
  int totalSale;
  int reward;
  int minimumOrderQuantity;
  bool isNew;
  bool hasVariant;

  CategoryProductData({

    required this.id,
    required this.slug,
    required this.title,
    required this.shortDescription,
    required this.specialDiscountType,
    required this.specialDiscount,
    required this.discountPrice,
    required this.image,
    required this.price,
    required this.rating,
    required this.totalReviews,
    required this.currentStock,
    required this.totalSale,
    required this.reward,
    required this.minimumOrderQuantity,
    required this.isNew,
    required this.hasVariant,

  });

  factory CategoryProductData.fromJson(Map<String, dynamic>? json) {

    if (json == null) {
      return CategoryProductData(
        id: 0,
        slug: "",
        title: "",
        shortDescription: "",
        specialDiscountType: "",
        specialDiscount: 0,
        discountPrice: 0,
        image: "",
        price: 0,
        rating: 0,
        totalReviews: 0,
        currentStock: 0,
        totalSale: 0,
        reward: 0,
        minimumOrderQuantity: 1,
        isNew: false,
        hasVariant: false,
      );
    }

    return CategoryProductData(

      id: _toInt(json['id']),
      slug: json['slug']?.toString() ?? "",
      title: json['title']?.toString() ?? "",
      shortDescription: json['short_description']?.toString() ?? "",
      specialDiscountType: json['special_discount_type']?.toString() ?? "",
      specialDiscount: _toDouble(json['special_discount']),
      discountPrice: _toDouble(json['discount_price']),
      image: json['image']?.toString() ?? "",
      price: _toDouble(json['price']),
      rating: _toDouble(json['rating']),
      totalReviews: _toInt(json['reviews_count']), // ✅ API utilise reviews_count
      currentStock: _toInt(json['current_stock']),
      totalSale: _toInt(json['total_sale']),
      reward: _toInt(json['reward']),
      minimumOrderQuantity: _toInt(json['minimum_order_quantity']),
      isNew: _toBool(json['is_new']),
      hasVariant: _toBool(json['has_variant']),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "slug": slug,
      "title": title,
      "short_description": shortDescription,
      "special_discount_type": specialDiscountType,
      "special_discount": specialDiscount,
      "discount_price": discountPrice,
      "image": image,
      "price": price,
      "rating": rating,
      "total_reviews": totalReviews,
      "current_stock": currentStock,
      "total_sale": totalSale,
      "reward": reward,
      "minimum_order_quantity": minimumOrderQuantity,
      "is_new": isNew,
      "has_variant": hasVariant,
    };
  }

  // ================= SAFE PARSERS =================

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    return value.toString().toLowerCase() == "true";
  }

}

