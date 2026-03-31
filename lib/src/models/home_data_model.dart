class HomeDataModel {
  bool? success;
  String? message;
  List<Data>? data;

  HomeDataModel({this.success, this.message, this.data});

  // ✅ CORRECTION : success peut arriver comme bool OU comme string "true"
  HomeDataModel.fromJson(dynamic json) {

    /// protection JSON null ou mauvais type
    if (json == null || json is! Map<String, dynamic>) {
      success = false;
      message = "";
      data = [];
      return;
    }

    /// success peut être bool ou string
    success = json['success'] is bool
        ? json['success']
        : (json['success']?.toString() == 'true');

    message = json['message']?.toString() ?? "";

    /// parsing sécurisé de la liste
    if (json['data'] is List) {

      data = (json['data'] as List)
          .where((e) => e != null && e is Map<String, dynamic>)
          .map((e) => Data.fromJson(e))
          .toList();

    } else {
      data = [];

    }

  }

  // ✅ AJOUT : modèle vide pour éviter les null en cascade
  factory HomeDataModel.empty() =>
      HomeDataModel(success: false, message: '', data: []);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? icon;
  int? parentId;
  String? slug;
  String? title;
  String? image;

  Categories({
    this.id,
    this.icon,
    this.parentId,
    this.slug,
    this.title,
    this.image,
  });

  Categories.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    icon = json['icon']?.toString();
    parentId = _parseInt(json['parent_id']);
    slug = json['slug']?.toString();
    title = json['title']?.toString() ?? "No Title";
    image = json['image']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['icon'] = icon;
    data['parent_id'] = parentId;
    data['slug'] = slug;
    data['title'] = title;
    data['image'] = image;
    return data;
  }
}

class Data {
  String? sectionType;
  List<Slider>? slider;
  List<Benefits>? benefits;
  List<Categories>? categories;
  List<Banners>? banners;
  List<Campaigns>? campaigns;
  List<PopularCategories>? popularCategories;
  List<TopCategories>? topCategories;
  List<TodayDeals>? todayDeals;
  List<FlashDeals>? flashDeals;
  String? categorySecBanner;
  String? categorySecBannerUrl;
  CategorySection? categorySection;
  List<VideoShopping>? videoShopping;
  List<BestSellingProducts>? bestSellingProducts;
  List<OfferEnding>? offerEnding;
  String? offerEndingBanner;
  String? offerEndingBannerUrl;
  List<LatestProducts>? latestProducts;
  List<LatestNews>? latestNews;
  List<PopularBrands>? popularBrands;
  List<TopShops>? topShops;
  List<FeaturedShops>? featuredShops;
  List<BestShops>? bestShops;
  List<ExpressShops>? expressShops;
  List<RecentViewedProduct>? recentViewedProduct;
  List<CustomProduct>? customProducts;
  bool? subscriptionSection;

  Data({
    this.sectionType,
    this.slider,
    this.benefits,
    this.banners,
    this.campaigns,
    this.popularCategories,
    this.topCategories,
    this.todayDeals,
    this.flashDeals,
    this.categorySecBanner,
    this.categorySecBannerUrl,
    this.categorySection,
    this.videoShopping,
    this.bestSellingProducts,
    this.offerEnding,
    this.offerEndingBanner,
    this.offerEndingBannerUrl,
    this.latestProducts,
    this.latestNews,
    this.popularBrands,
    this.topShops,
    this.featuredShops,
    this.bestShops,
    this.expressShops,
    this.recentViewedProduct,
    this.subscriptionSection,
    this.categories,
    this.customProducts,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sectionType = json['section_type']?.toString() ?? '';

    if (sectionType == 'slider') {
      if (json['slider'] != null) {
        slider = <Slider>[];
        json['slider'].forEach((v) {
          if (v is Map<String, dynamic>) slider!.add(Slider.fromJson(v));
        });
      }
    } else if (sectionType == 'categories') {
      if (json['categories'] != null) {
        categories = <Categories>[];
        json['categories'].forEach((v) {
          if (v is Map<String, dynamic>) categories!.add(Categories.fromJson(v));
        });
      }
    } else if (sectionType == 'benefits') {
      if (json['benefits'] != null) {
        benefits = <Benefits>[];
        json['benefits'].forEach((v) {
          if (v is Map<String, dynamic>) benefits!.add(Benefits.fromJson(v));
        });
      }
    } else if (sectionType == 'banners') {
      if (json['banners'] != null) {
        banners = <Banners>[];
        json['banners'].forEach((v) {
          if (v is Map<String, dynamic>) banners!.add(Banners.fromJson(v));
        });
      }
    } else if (sectionType == 'campaigns') {
      if (json['campaigns'] != null) {
        campaigns = <Campaigns>[];
        json['campaigns'].forEach((v) {
          if (v is Map<String, dynamic>) campaigns!.add(Campaigns.fromJson(v));
        });
      }
    } else if (sectionType == 'popular_categories') {
      if (json['popular_categories'] != null) {
        popularCategories = <PopularCategories>[];
        json['popular_categories'].forEach((v) {
          if (v is Map<String, dynamic>) popularCategories!.add(PopularCategories.fromJson(v));
        });
      }
    } else if (sectionType == 'top_categories') {
      if (json['top_categories'] != null) {
        topCategories = <TopCategories>[];
        json['top_categories'].forEach((v) {
          if (v is Map<String, dynamic>) topCategories!.add(TopCategories.fromJson(v));
        });
      }
    } else if (sectionType == 'today_deals') {
      if (json['today_deals'] != null) {
        todayDeals = <TodayDeals>[];
        json['today_deals'].forEach((v) {
          if (v is Map<String, dynamic>) todayDeals!.add(TodayDeals.fromJson(v));
        });
      }
    } else if (sectionType == 'flash_deals') {
      if (json['flash_deals'] != null) {
        flashDeals = <FlashDeals>[];
        json['flash_deals'].forEach((v) {
          if (v is Map<String, dynamic>) flashDeals!.add(FlashDeals.fromJson(v));
        });
      }
    } else if (sectionType == 'best_selling_products') {
      if (json['best_selling_products'] != null) {
        bestSellingProducts = <BestSellingProducts>[];
        json['best_selling_products'].forEach((v) {
          if (v is Map<String, dynamic>) bestSellingProducts!.add(BestSellingProducts.fromJson(v));
        });
      }
    } else if (sectionType == 'offer_ending') {
      if (json['offer_ending'] != null) {
        offerEnding = <OfferEnding>[];
        json['offer_ending'].forEach((v) {
          if (v is Map<String, dynamic>) offerEnding!.add(OfferEnding.fromJson(v));
        });
      }
    } else if (sectionType == 'latest_products') {
      if (json['latest_products'] != null) {
        latestProducts = <LatestProducts>[];
        json['latest_products'].forEach((v) {
          if (v is Map<String, dynamic>) latestProducts!.add(LatestProducts.fromJson(v));
        });
      }
    } else if (sectionType == 'latest_news') {
      if (json['latest_news'] != null) {
        latestNews = <LatestNews>[];
        json['latest_news'].forEach((v) {
          if (v is Map<String, dynamic>) latestNews!.add(LatestNews.fromJson(v));
        });
      }
    } else if (sectionType == 'popular_brands') {
      if (json['popular_brands'] != null) {
        popularBrands = <PopularBrands>[];
        json['popular_brands'].forEach((v) {
          if (v is Map<String, dynamic>) popularBrands!.add(PopularBrands.fromJson(v));
        });
      }
    } else if (sectionType == 'top_shops') {
      if (json['top_shops'] != null) {
        topShops = <TopShops>[];
        json['top_shops'].forEach((v) {
          if (v is Map<String, dynamic>) topShops!.add(TopShops.fromJson(v));
        });
      }
    } else if (sectionType == 'featured_shops') {
      if (json['featured_shops'] != null) {
        featuredShops = <FeaturedShops>[];
        json['featured_shops'].forEach((v) {
          if (v is Map<String, dynamic>) featuredShops!.add(FeaturedShops.fromJson(v));
        });
      }
    } else if (sectionType == 'best_shops') {
      if (json['best_shops'] != null) {
        bestShops = <BestShops>[];
        json['best_shops'].forEach((v) {
          if (v is Map<String, dynamic>) bestShops!.add(BestShops.fromJson(v));
        });
      }
    } else if (sectionType == 'express_shops') {
      if (json['express_shops'] != null) {
        expressShops = <ExpressShops>[];
        json['express_shops'].forEach((v) {
          if (v is Map<String, dynamic>) expressShops!.add(ExpressShops.fromJson(v));
        });
      }
    } else if (sectionType == 'recent_viewed_product') {
      if (json['recent_viewed_product'] != null) {
        recentViewedProduct = <RecentViewedProduct>[];
        json['recent_viewed_product'].forEach((v) {
          if (v is Map<String, dynamic>) recentViewedProduct!.add(RecentViewedProduct.fromJson(v));
        });
      }
    } else if (sectionType == 'custom_products') {
      if (json['custom_products'] != null) {
        customProducts = <CustomProduct>[];
        json['custom_products'].forEach((v) {
          if (v is Map<String, dynamic>) customProducts!.add(CustomProduct.fromJson(v));
        });
      }
    } else if (sectionType == 'video_shopping') {
      if (json['video_shopping'] != null) {
        videoShopping = <VideoShopping>[];
        json['video_shopping'].forEach((v) {
          if (v is Map<String, dynamic>) videoShopping!.add(VideoShopping.fromJson(v));
        });
      }
    }

    categorySecBanner = json['category_sec_banner']?.toString();
    categorySecBannerUrl = json['category_sec_banner_url']?.toString();
    categorySection = json['category_section'] != null && json['category_section'] is Map<String, dynamic>
        ? CategorySection.fromJson(json['category_section'])
        : null;

    offerEndingBanner = json['offer_ending_banner']?.toString();
    offerEndingBannerUrl = json['offer_ending_banner_url']?.toString();

    // ✅ CORRECTION : subscription_section peut être null, bool ou int (0/1)
    subscriptionSection = _parseBool(json['subscription_section']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['section_type'] = sectionType;
    if (slider != null) {
      data['slider'] = slider!.map((v) => v.toJson()).toList();
    }
    if (benefits != null) {
      data['benefits'] = benefits!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (banners != null) {
      data['banners'] = banners!.map((v) => v.toJson()).toList();
    }
    if (campaigns != null) {
      data['campaigns'] = campaigns!.map((v) => v.toJson()).toList();
    }
    if (popularCategories != null) {
      data['popular_categories'] =
          popularCategories!.map((v) => v.toJson()).toList();
    }
    if (topCategories != null) {
      data['top_categories'] = topCategories!.map((v) => v.toJson()).toList();
    }
    if (todayDeals != null) {
      data['today_deals'] = todayDeals!.map((v) => v.toJson()).toList();
    }
    if (flashDeals != null) {
      data['flash_products'] = flashDeals!.map((v) => v.toJson()).toList();
    }
    data['category_sec_banner'] = categorySecBanner;
    data['category_sec_banner_url'] = categorySecBannerUrl;
    if (categorySection != null) {
      data['category_section'] = categorySection!.toJson();
    }
    if (videoShopping != null) {
      data['video_shopping'] = videoShopping!.map((v) => v.toJson()).toList();
    }
    if (bestSellingProducts != null) {
      data['best_selling_products'] =
          bestSellingProducts!.map((v) => v.toJson()).toList();
    }
    if (offerEnding != null) {
      data['offer_ending'] = offerEnding!.map((v) => v.toJson()).toList();
    }
    data['offer_ending_banner'] = offerEndingBanner;
    data['offer_ending_banner_url'] = offerEndingBannerUrl;
    if (latestProducts != null) {
      data['latest_products'] = latestProducts!.map((v) => v.toJson()).toList();
    }
    if (latestNews != null) {
      data['latest_news'] = latestNews!.map((v) => v.toJson()).toList();
    }
    if (popularBrands != null) {
      data['popular_brands'] = popularBrands!.map((v) => v.toJson()).toList();
    }
    if (topShops != null) {
      data['top_shops'] = topShops!.map((v) => v.toJson()).toList();
    }
    if (featuredShops != null) {
      data['featured_shops'] = featuredShops!.map((v) => v.toJson()).toList();
    }
    if (bestShops != null) {
      data['best_shops'] = bestShops!.map((v) => v.toJson()).toList();
    }
    if (expressShops != null) {
      data['express_shops'] = expressShops!.map((v) => v.toJson()).toList();
    }
    if (recentViewedProduct != null) {
      data['recent_viewed_product'] =
          recentViewedProduct!.map((v) => v.toJson()).toList();
    }
    if (customProducts != null) {
      data['custom_products'] = customProducts!.map((v) => v.toJson()).toList();
    }
    data['subscription_section'] = subscriptionSection;
    return data;
  }
}

// ============================================================
// FONCTIONS UTILITAIRES PARTAGÉES (en bas du fichier)
// ============================================================

// ✅ Parse un bool depuis n'importe quel type : bool, int (0/1), String ("true"/"1")
bool? _parseBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return value == 'true' || value == '1';
  return null;
}

// ✅ Parse un int depuis n'importe quel type sans crash
int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

// ============================================================

class VideoShopping {
  int? id;
  String? slug;
  bool? isLive;
  String? thumbnail;
  String? title;

  VideoShopping({this.id, this.slug, this.isLive, this.thumbnail, this.title});

  VideoShopping.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    isLive = _parseBool(json['is_live']); // ✅ CORRECTION
    thumbnail = json['thumbnail']?.toString();
    title = json['title']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['is_live'] = isLive;
    data['thumbnail'] = thumbnail;
    data['title'] = title;
    return data;
  }
}

class BestShops {
  int? id;
  String? slug;
  String? logo;
  String? banner;
  dynamic rating;
  dynamic totalReviews;
  String? shopName;
  bool? isFollowed;
  List<Products>? products;

  BestShops({
    this.id,
    this.slug,
    this.logo,
    this.banner,
    this.rating,
    this.totalReviews,
    this.shopName,
    this.isFollowed,
    this.products,
  });

  BestShops.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    logo = json['logo']?.toString();
    banner = json['banner']?.toString();
    rating = json['rating'];
    totalReviews = json['total_reviews'];
    shopName = json['shop_name']?.toString();
    isFollowed = _parseBool(json['is_followed']); // ✅ CORRECTION
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        if (v is Map<String, dynamic>) products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['logo'] = logo;
    data['banner'] = banner;
    data['rating'] = rating;
    data['total_reviews'] = totalReviews;
    data['shop_name'] = shopName;
    data['is_followed'] = isFollowed;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExpressShops {
  int? id;
  String? slug;
  String? logo;
  String? banner;
  dynamic rating;
  dynamic totalReviews;
  String? shopName;
  bool? isFollowed;

  ExpressShops({
    this.id,
    this.slug,
    this.logo,
    this.banner,
    this.rating,
    this.totalReviews,
    this.shopName,
    this.isFollowed,
  });

  ExpressShops.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    logo = json['logo']?.toString();
    banner = json['banner']?.toString();
    rating = json['rating'];
    totalReviews = json['total_reviews'];
    shopName = json['shop_name']?.toString();
    isFollowed = _parseBool(json['is_followed']); // ✅ CORRECTION
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['logo'] = logo;
    data['banner'] = banner;
    data['rating'] = rating;
    data['total_reviews'] = totalReviews;
    data['shop_name'] = shopName;
    data['is_followed'] = isFollowed;
    return data;
  }
}

class RecentViewedProduct {
  int? id;
  String? slug;
  String? title;
  String? shortDescription;
  String? specialDiscountType;
  String? specialDiscount;
  String? discountPrice;
  String? image;
  String? price;
  dynamic rating;
  int? totalReviews;
  int? currentStock;
  int? reward;
  int? minimumOrderQuantity;
  bool isNew = false;
  bool hasVariant = false;

  RecentViewedProduct({
    this.id,
    this.slug,
    this.title,
    this.shortDescription,
    this.specialDiscountType,
    this.specialDiscount,
    this.discountPrice,
    this.image,
    this.price,
    this.rating,
    this.totalReviews,
    this.currentStock,
    this.reward,
    this.minimumOrderQuantity,
    this.isNew = false,
    this.hasVariant = false,
  });

  /// ✅ CONSTRUCTEUR SAFE (aucun crash possible)
  RecentViewedProduct.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    title = json['title']?.toString();
    shortDescription = json['short_description']?.toString();
    specialDiscountType = json['special_discount_type']?.toString();
    specialDiscount = json['special_discount']?.toString();
    discountPrice = json['discount_price']?.toString();
    image = json['image']?.toString();
    price = json['price']?.toString();

    rating = json['rating'];

    totalReviews = _parseInt(json['total_reviews']);
    currentStock = _parseInt(json['current_stock']);
    reward = _parseInt(json['reward']);
    minimumOrderQuantity = _parseInt(json['minimum_order_quantity']);

    /// ✅ FIX CRITIQUE DEFINITIF
    isNew = _parseBoolSafe(json['is_new']);
    hasVariant = _parseBoolSafe(json['has_variant']);
  }

  /// ✅ CONVERSION JSON SAFE
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'short_description': shortDescription,
      'special_discount_type': specialDiscountType,
      'special_discount': specialDiscount,
      'discount_price': discountPrice,
      'image': image,
      'price': price,
      'rating': rating,
      'total_reviews': totalReviews,
      'current_stock': currentStock,
      'reward': reward,
      'minimum_order_quantity': minimumOrderQuantity,
      'is_new': isNew,
      'has_variant': hasVariant,
    };
  }

  /// ================================
  /// SAFE PARSERS (ANTI-CRASH)
  /// ================================

  static int _parseInt(dynamic value) {
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

  static bool _parseBoolSafe(dynamic value) {
    if (value == null) return false;

    if (value is bool) return value;

    if (value is int) return value == 1;

    if (value is String) {
      return value.toLowerCase() == "true" || value == "1";
    }

    return false;
  }
}


class CustomProduct {
  int? id;
  String? slug;
  String? title;
  String? shortDescription;
  String? specialDiscountType;
  String? specialDiscount;
  String? discountPrice;
  String? image;
  String? price;
  dynamic rating;
  int? totalReviews;
  int? currentStock;
  int? reward;
  int? minimumOrderQuantity;
  bool? isNew;
  bool? hasVariant;
  bool? isFavourite;

  CustomProduct({
    this.id,
    this.slug,
    this.title,
    this.shortDescription,
    this.specialDiscountType,
    this.specialDiscount,
    this.discountPrice,
    this.image,
    this.price,
    this.rating,
    this.totalReviews,
    this.currentStock,
    this.reward,
    this.minimumOrderQuantity,
    this.isNew,
    this.hasVariant,
    this.isFavourite,
  });

  CustomProduct.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    title = json['title']?.toString();
    shortDescription = json['short_description']?.toString();
    specialDiscountType = json['special_discount_type']?.toString();
    specialDiscount = json['special_discount']?.toString();
    discountPrice = json['discount_price']?.toString();
    image = json['image']?.toString();
    price = json['price']?.toString();
    rating = json['rating'];
    totalReviews = _parseInt(json['total_reviews']);
    currentStock = _parseInt(json['current_stock']);
    reward = _parseInt(json['reward']);
    minimumOrderQuantity = _parseInt(json['minimum_order_quantity']);
    isNew = _parseBool(json['is_new']);           // ✅ CORRECTION
    hasVariant = _parseBool(json['has_variant']);  // ✅ CORRECTION
    isFavourite = _parseBool(json['is_favourite']); // ✅ CORRECTION
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['special_discount_type'] = specialDiscountType;
    data['special_discount'] = specialDiscount;
    data['discount_price'] = discountPrice;
    data['image'] = image;
    data['price'] = price;
    data['rating'] = rating;
    data['total_reviews'] = totalReviews;
    data['current_stock'] = currentStock;
    data['reward'] = reward;
    data['minimum_order_quantity'] = minimumOrderQuantity;
    data['is_new'] = isNew;
    data['has_variant'] = hasVariant;
    data['is_favourite'] = isFavourite;
    return data;
  }
}

class Products {
  int? id;
  String? slug;
  String? title;
  String? shortDescription;
  String? specialDiscountType;
  String? specialDiscount;
  String? discountPrice;
  String? image;
  String? price;
  dynamic rating;
  int? totalReviews;
  int? currentStock;
  int? reward;
  int? minimumOrderQuantity;

  Products({
    this.id,
    this.slug,
    this.title,
    this.shortDescription,
    this.specialDiscountType,
    this.specialDiscount,
    this.discountPrice,
    this.image,
    this.price,
    this.rating,
    this.totalReviews,
    this.currentStock,
    this.reward,
    this.minimumOrderQuantity,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    title = json['title']?.toString();
    shortDescription = json['short_description']?.toString();
    specialDiscountType = json['special_discount_type']?.toString();
    specialDiscount = json['special_discount']?.toString();
    discountPrice = json['discount_price']?.toString();
    image = json['image']?.toString();
    price = json['price']?.toString();
    rating = json['rating'];
    totalReviews = _parseInt(json['total_reviews']);
    currentStock = _parseInt(json['current_stock']);
    reward = _parseInt(json['reward']);
    minimumOrderQuantity = _parseInt(json['minimum_order_quantity']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['special_discount_type'] = specialDiscountType;
    data['special_discount'] = specialDiscount;
    data['discount_price'] = discountPrice;
    data['image'] = image;
    data['price'] = price;
    data['rating'] = rating;
    data['total_reviews'] = totalReviews;
    data['current_stock'] = currentStock;
    data['reward'] = reward;
    data['minimum_order_quantity'] = minimumOrderQuantity;
    return data;
  }
}

class LatestProducts {
  int? id;
  String? slug;
  String? title;
  String? shortDescription;
  String? specialDiscountType;
  String? specialDiscount;
  dynamic discountPrice;
  String? image;
  dynamic price;
  dynamic rating;
  int? totalReviews;
  int? currentStock;
  int? reward;
  int? minimumOrderQuantity;
  bool? isFavourite;
  bool? isNew;
  bool? hasVariant;

  LatestProducts({
    this.id,
    this.slug,
    this.title,
    this.shortDescription,
    this.specialDiscountType,
    this.specialDiscount,
    this.discountPrice,
    this.image,
    this.price,
    this.rating,
    this.totalReviews,
    this.currentStock,
    this.reward,
    this.minimumOrderQuantity,
    this.isFavourite,
    this.isNew,
    this.hasVariant,
  });

  LatestProducts.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    title = json['title']?.toString();
    shortDescription = json['short_description']?.toString();
    specialDiscountType = json['special_discount_type']?.toString();
    specialDiscount = json['special_discount']?.toString();
    discountPrice = json['discount_price'];
    image = json['image']?.toString();
    price = json['price'];
    rating = json['rating'];
    totalReviews = _parseInt(json['total_reviews']);
    currentStock = _parseInt(json['current_stock']);
    reward = _parseInt(json['reward']);
    minimumOrderQuantity = _parseInt(json['minimum_order_quantity']);
    isFavourite = _parseBool(json['is_favourite']); // ✅ CORRECTION
    isNew = _parseBool(json['is_new']);              // ✅ CORRECTION
    hasVariant = _parseBool(json['has_variant']);    // ✅ CORRECTION
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['special_discount_type'] = specialDiscountType;
    data['special_discount'] = specialDiscount;
    data['discount_price'] = discountPrice;
    data['image'] = image;
    data['price'] = price;
    data['rating'] = rating;
    data['total_reviews'] = totalReviews;
    data['current_stock'] = currentStock;
    data['reward'] = reward;
    data['minimum_order_quantity'] = minimumOrderQuantity;
    data['is_favourite'] = isFavourite;
    data['is_new'] = isNew;
    data['has_variant'] = hasVariant;
    return data;
  }
}

class OfferEnding {
  int? id;
  String? slug;
  String? title;
  String? shortDescription;
  dynamic specialDiscountType;
  String? specialDiscount;
  dynamic discountPrice;
  String? image;
  dynamic price;
  dynamic rating;
  int? totalReviews;
  int? currentStock;
  int? reward;
  int? minimumOrderQuantity;
  bool? isFavourite;
  bool? isNew;
  bool? hasVariant;

  OfferEnding({
    this.id,
    this.slug,
    this.title,
    this.shortDescription,
    this.specialDiscountType,
    this.specialDiscount,
    this.discountPrice,
    this.image,
    this.price,
    this.rating,
    this.totalReviews,
    this.currentStock,
    this.reward,
    this.minimumOrderQuantity,
    this.isFavourite,
    this.isNew,
    this.hasVariant,
  });

  OfferEnding.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    title = json['title']?.toString();
    shortDescription = json['short_description']?.toString();
    specialDiscountType = json['special_discount_type'];
    specialDiscount = json['special_discount']?.toString();
    discountPrice = json['discount_price'];
    image = json['image']?.toString();
    price = json['price'];
    rating = json['rating'];
    totalReviews = _parseInt(json['total_reviews']);
    currentStock = _parseInt(json['current_stock']);
    reward = _parseInt(json['reward']);
    minimumOrderQuantity = _parseInt(json['minimum_order_quantity']);
    isFavourite = _parseBool(json['is_favourite']); // ✅ CORRECTION
    isNew = _parseBool(json['is_new']);              // ✅ CORRECTION
    hasVariant = _parseBool(json['has_variant']);    // ✅ CORRECTION
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['special_discount_type'] = specialDiscountType;
    data['special_discount'] = specialDiscount;
    data['discount_price'] = discountPrice;
    data['image'] = image;
    data['price'] = price;
    data['rating'] = rating;
    data['total_reviews'] = totalReviews;
    data['current_stock'] = currentStock;
    data['reward'] = reward;
    data['minimum_order_quantity'] = minimumOrderQuantity;
    data['is_favourite'] = isFavourite;
    data['is_new'] = isNew;
    data['has_variant'] = hasVariant;
    return data;
  }
}

class BestSellingProducts {
  int? id;
  String? slug;
  String? title;
  String? shortDescription;
  String? specialDiscountType;
  String? specialDiscount;
  dynamic discountPrice;
  String? image;
  dynamic price;
  dynamic rating;
  int? totalReviews;
  int? currentStock;
  int? reward;
  int? minimumOrderQuantity;
  bool? isFavourite;
  bool? isNew;
  bool? hasVariant;

  BestSellingProducts({
    this.id,
    this.slug,
    this.title,
    this.shortDescription,
    this.specialDiscountType,
    this.specialDiscount,
    this.discountPrice,
    this.image,
    this.price,
    this.rating,
    this.totalReviews,
    this.currentStock,
    this.reward,
    this.minimumOrderQuantity,
    this.isFavourite,
    this.isNew,
    this.hasVariant,
  });

  BestSellingProducts.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    title = json['title']?.toString();
    shortDescription = json['short_description']?.toString();
    specialDiscountType = json['special_discount_type']?.toString();
    specialDiscount = json['special_discount']?.toString();
    discountPrice = json['discount_price'];
    image = json['image']?.toString();
    price = json['price'];
    rating = json['rating'];
    totalReviews = _parseInt(json['total_reviews']);
    currentStock = _parseInt(json['current_stock']);
    reward = _parseInt(json['reward']);
    minimumOrderQuantity = _parseInt(json['minimum_order_quantity']);
    isFavourite = _parseBool(json['is_favourite']); // ✅ CORRECTION
    isNew = _parseBool(json['is_new']);              // ✅ CORRECTION
    hasVariant = _parseBool(json['has_variant']);    // ✅ CORRECTION
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['special_discount_type'] = specialDiscountType;
    data['special_discount'] = specialDiscount;
    data['discount_price'] = discountPrice;
    data['image'] = image;
    data['price'] = price;
    data['rating'] = rating;
    data['total_reviews'] = totalReviews;
    data['current_stock'] = currentStock;
    data['reward'] = reward;
    data['minimum_order_quantity'] = minimumOrderQuantity;
    data['is_favourite'] = isFavourite;
    data['is_new'] = isNew;
    data['has_variant'] = hasVariant;
    return data;
  }
}

class TopCategories {
  int? id;
  String? icon;
  dynamic parentId;
  String? slug;
  String? title;
  String? image;

  TopCategories({
    this.id,
    this.icon,
    this.parentId,
    this.slug,
    this.title,
    this.image,
  });

  TopCategories.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    icon = json['icon']?.toString();
    parentId = json['parent_id'];
    slug = json['slug']?.toString();
    title = json['title']?.toString() ?? "No Title";
    image = json['image']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['icon'] = icon;
    data['parent_id'] = parentId;
    data['slug'] = slug;
    data['title'] = title;
    data['image'] = image;
    return data;
  }
}

class Slider {
  int? id;
  String? title;
  String? url;
  String? backgroundImage;
  String? banner;
  String? actionType;
  dynamic actionTo;

  Slider({
    this.id,
    this.title,
    this.url,
    this.backgroundImage,
    this.banner,
    this.actionTo,
    this.actionType,
  });

  Slider.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    title = json['title']?.toString();
    url = json['url']?.toString();
    backgroundImage = json['background_image']?.toString();
    banner = json['banner']?.toString();
    actionTo = json['action_to'];
    actionType = json['action_type']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['url'] = url;
    data['background_image'] = backgroundImage;
    data['banner'] = banner;
    data['action_to'] = actionTo;
    data['action_type'] = actionType;
    return data;
  }
}

class Benefits {
  int? id;
  String? title;
  String? subTile;
  String? image;

  Benefits({this.id, this.title, this.subTile, this.image});

  Benefits.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    title = json['title']?.toString();
    subTile = json['sub_tile']?.toString();
    image = json['image']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['sub_tile'] = subTile;
    data['image'] = image;
    return data;
  }
}

class Banners {
  String? thumbnail;
  String? actionType;
  String? actionTo;
  String? actionId;

  Banners({this.thumbnail, this.actionTo, this.actionType, this.actionId});

  Banners.fromJson(Map<String, dynamic> json) {
    thumbnail = json['thumbnail']?.toString();
    actionType = json['action_type']?.toString();
    actionTo = json['action_to']?.toString();
    actionId = json['action_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thumbnail'] = thumbnail;
    data['action_type'] = actionType;
    data['action_to'] = actionTo;
    data['action_id'] = actionId;
    return data;
  }
}

class Campaigns {
  int? id;
  String? slug;
  String? title;
  String? shortDescription;
  String? startDate;
  String? endDate;
  String? banner;

  Campaigns({
    this.id,
    this.slug,
    this.title,
    this.shortDescription,
    this.startDate,
    this.endDate,
    this.banner,
  });

  Campaigns.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    title = json['title']?.toString();
    shortDescription = json['short_description']?.toString();
    startDate = json['start_date']?.toString();
    endDate = json['end_date']?.toString();
    banner = json['banner']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['banner'] = banner;
    return data;
  }
}

class PopularCategories {
  int? id;
  String? icon;
  dynamic parentId;
  String? slug;
  String? title;
  String? image;

  PopularCategories({
    this.id,
    this.icon,
    this.parentId,
    this.slug,
    this.title,
    this.image,
  });

  PopularCategories.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    icon = json['icon']?.toString();
    parentId = json['parent_id'];
    slug = json['slug']?.toString();
    title = json['title']?.toString() ?? "No Title";
    image = json['image']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['icon'] = icon;
    data['parent_id'] = parentId;
    data['slug'] = slug;
    data['title'] = title;
    data['image'] = image;
    return data;
  }
}

class TodayDeals {
  int? id;
  String? slug;
  String? title;
  String? shortDescription;
  String? specialDiscountType;
  String? specialDiscount;
  dynamic discountPrice;
  String? image;
  dynamic price;
  dynamic rating;
  int? totalReviews;
  int? currentStock;
  int? reward;
  int? minimumOrderQuantity;
  bool? isFavourite;
  bool? isNew;
  bool? hasVariant;

  TodayDeals({
    this.id,
    this.slug,
    this.title,
    this.shortDescription,
    this.specialDiscountType,
    this.specialDiscount,
    this.discountPrice,
    this.image,
    this.price,
    this.rating,
    this.totalReviews,
    this.currentStock,
    this.reward,
    this.minimumOrderQuantity,
    this.isFavourite,
    this.isNew,
    this.hasVariant,
  });

  TodayDeals.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    title = json['title']?.toString();
    shortDescription = json['short_description']?.toString();
    specialDiscountType = json['special_discount_type']?.toString();
    specialDiscount = json['special_discount']?.toString();
    discountPrice = json['discount_price'];
    image = json['image']?.toString();
    price = json['price'];
    rating = json['rating'];
    totalReviews = _parseInt(json['total_reviews']);
    currentStock = _parseInt(json['current_stock']);
    reward = _parseInt(json['reward']);
    minimumOrderQuantity = _parseInt(json['minimum_order_quantity']);
    isFavourite = _parseBool(json['is_favourite']); // ✅ CORRECTION
    isNew = _parseBool(json['is_new']);              // ✅ CORRECTION
    hasVariant = _parseBool(json['has_variant']);    // ✅ CORRECTION
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['special_discount_type'] = specialDiscountType;
    data['special_discount'] = specialDiscount;
    data['discount_price'] = discountPrice;
    data['image'] = image;
    data['price'] = price;
    data['rating'] = rating;
    data['total_reviews'] = totalReviews;
    data['current_stock'] = currentStock;
    data['reward'] = reward;
    data['minimum_order_quantity'] = minimumOrderQuantity;
    data['is_favourite'] = isFavourite;
    data['is_new'] = isNew;
    data['has_variant'] = hasVariant;
    return data;
  }
}

class FlashDeals {
  int? id;
  String? slug;
  String? title;
  String? shortDescription;
  String? specialDiscountType;
  String? specialDiscount;
  dynamic discountPrice;
  String? image;
  dynamic price;
  dynamic rating;
  int? totalReviews;
  int? currentStock;
  int? reward;
  int? minimumOrderQuantity;
  bool? isFavourite;
  bool? isNew;
  bool? hasVariant;

  FlashDeals({
    this.id,
    this.slug,
    this.title,
    this.shortDescription,
    this.specialDiscountType,
    this.specialDiscount,
    this.discountPrice,
    this.image,
    this.price,
    this.rating,
    this.totalReviews,
    this.currentStock,
    this.reward,
    this.minimumOrderQuantity,
    this.isFavourite,
    this.isNew,
    this.hasVariant,
  });

  FlashDeals.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    title = json['title']?.toString();
    shortDescription = json['short_description']?.toString();
    specialDiscountType = json['special_discount_type']?.toString();
    specialDiscount = json['special_discount']?.toString();
    discountPrice = json['discount_price'];
    image = json['image']?.toString();
    price = json['price'];
    rating = json['rating'];
    totalReviews = _parseInt(json['total_reviews']);
    currentStock = _parseInt(json['current_stock']);
    reward = _parseInt(json['reward']);
    minimumOrderQuantity = _parseInt(json['minimum_order_quantity']);
    isFavourite = _parseBool(json['is_favourite']); // ✅ CORRECTION
    isNew = _parseBool(json['is_new']);              // ✅ CORRECTION
    hasVariant = _parseBool(json['has_variant']);    // ✅ CORRECTION
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['special_discount_type'] = specialDiscountType;
    data['special_discount'] = specialDiscount;
    data['discount_price'] = discountPrice;
    data['image'] = image;
    data['price'] = price;
    data['rating'] = rating;
    data['total_reviews'] = totalReviews;
    data['current_stock'] = currentStock;
    data['reward'] = reward;
    data['minimum_order_quantity'] = minimumOrderQuantity;
    data['is_favourite'] = isFavourite;
    data['is_new'] = isNew;
    data['has_variant'] = hasVariant;
    return data;
  }
}

class CategorySection {
  int? id;
  String? slug;
  String? title;
  List<Products>? products;

  CategorySection({this.id, this.slug, this.title, this.products});

  CategorySection.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    title = json['title']?.toString();
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        if (v is Map<String, dynamic>) products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LatestNews {
  int? id;
  String? slug;
  String? title;
  String? shortDescription;
  String? thumbnail;
  String? url;

  LatestNews({
    this.id,
    this.slug,
    this.title,
    this.shortDescription,
    this.thumbnail,
    this.url,
  });

  LatestNews.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    title = json['title']?.toString();
    shortDescription = json['short_description']?.toString();
    thumbnail = json['thumbnail']?.toString();
    url = json['url']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['thumbnail'] = thumbnail;
    data['url'] = url;
    return data;
  }
}

class PopularBrands {
  int? id;
  String? slug;
  String? title;
  String? thumbnail;

  PopularBrands({this.id, this.slug, this.title, this.thumbnail});

  PopularBrands.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    title = json['title']?.toString();
    thumbnail = json['thumbnail']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['thumbnail'] = thumbnail;
    return data;
  }
}

class TopShops {
  int? id;
  String? slug;
  String? logo;
  String? banner;
  dynamic rating;
  dynamic totalReviews;
  String? shopName;
  bool? isFollowed;

  TopShops({
    this.id,
    this.slug,
    this.logo,
    this.banner,
    this.rating,
    this.totalReviews,
    this.shopName,
    this.isFollowed,
  });

  TopShops.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    logo = json['logo']?.toString();
    banner = json['banner']?.toString();
    rating = json['rating'];
    totalReviews = json['total_reviews'];
    shopName = json['shop_name']?.toString();
    isFollowed = _parseBool(json['is_followed']); // ✅ CORRECTION
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['logo'] = logo;
    data['banner'] = banner;
    data['rating'] = rating;
    data['total_reviews'] = totalReviews;
    data['shop_name'] = shopName;
    data['is_followed'] = isFollowed;
    return data;
  }
}

class FeaturedShops {
  int? id;
  String? slug;
  String? logo;
  String? banner;
  dynamic rating;
  dynamic totalReviews;
  String? shopName;
  List<Products>? products;
  bool? isFollowed;

  FeaturedShops({
    this.id,
    this.slug,
    this.logo,
    this.banner,
    this.rating,
    this.totalReviews,
    this.shopName,
    this.products,
    this.isFollowed,
  });

  FeaturedShops.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    slug = json['slug']?.toString();
    logo = json['logo']?.toString();
    banner = json['banner']?.toString();
    rating = json['rating'];
    totalReviews = json['total_reviews'];
    shopName = json['shop_name']?.toString();
    isFollowed = _parseBool(json['is_followed']); // ✅ CORRECTION
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        if (v is Map<String, dynamic>) products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['logo'] = logo;
    data['banner'] = banner;
    data['rating'] = rating;
    data['total_reviews'] = totalReviews;
    data['shop_name'] = shopName;
    data['is_followed'] = isFollowed;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}