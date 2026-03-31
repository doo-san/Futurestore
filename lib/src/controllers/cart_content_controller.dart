import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoori_ecommerce/src/models/add_to_cart_list_model.dart';
import 'package:yoori_ecommerce/src/models/coupon_applied_list.dart';
import 'package:yoori_ecommerce/src/utils/constants.dart';
import 'package:yoori_ecommerce/src/servers/repository.dart';
import 'package:yoori_ecommerce/src/data/local_data_helper.dart';

class CartContentController extends GetxController {

  final Rx<AddToCartListModel> _addToCartListModel =
      AddToCartListModel.empty().obs;

  AddToCartListModel get addToCartListModel =>
      _addToCartListModel.value;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  final _isCartUpdating = false.obs;
  bool get isCartUpdating => _isCartUpdating.value;

  final _updatingCartId = "".obs;
  String get updatingCartId => _updatingCartId.value;

  final _isIncreasing = false.obs;
  bool get isIncreasing => _isIncreasing.value;

  // État dédié au bouton "+" de l'ajout rapide au panier
  final _isAddingToCart = false.obs;
  bool get isAddingToCart => _isAddingToCart.value;

  final _addingProductId = ''.obs;
  String get addingProductId => _addingProductId.value;

  final Rx<CouponAppliedList> _appliedCouponList =
      CouponAppliedList().obs;

  CouponAppliedList get appliedCouponList =>
      _appliedCouponList.value;

  final _isAplyingCoupon = false.obs;
  bool get isAplyingCoupon => _isAplyingCoupon.value;

  var couponCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCartList();
    getAppliedCouponList();
  }

  // 🔐 SAFE INDEX
  int incrementProduct(int productId) {
    final carts = _addToCartListModel.value.data?.carts;
    if (carts == null) return -1;
    return carts.indexWhere((e) => e.productId == productId);
  }

  // 🔥 FIX CRASH ICI
  Future getCartList({bool isShowLoading = true}) async {
    _isLoading(isShowLoading);

    try {
      final value = await Repository().getCartItemList();

      if (value.data != null &&
          value.data!.carts != null) {

        _addToCartListModel.value = value;

      } else {

        _addToCartListModel.value =
            AddToCartListModel.empty();
      }

    } catch (e, stack) {

      printLog("Cart Error: $e");
      print(stack);

      _addToCartListModel.value =
          AddToCartListModel.empty();
    }

    _isLoading(false);
  }

  Future addToCart({
    required String productId,
    required String quantity,
    String? variantsIds,
    String? variantsNames,
    String? productName,
  }) async {
    _isAddingToCart(true);
    _addingProductId.value = productId;

    String? trxId = LocalDataHelper().getCartTrxId();

    try {
      if (trxId == null) {
        await Repository().addToCartWithOutTrxId(
          productId: productId,
          quantity: quantity,
          variantsIds: variantsIds,
          variantsNames: variantsNames,
        );
      } else {
        await Repository().addToCartWithTrxId(
          productId: productId,
          quantity: quantity,
          variantsIds: variantsIds,
          variantsNames: variantsNames,
          trxId: trxId,
        );
      }

      await getCartList(isShowLoading: false);

      // Feedback visuel — confirmation d'ajout au panier
      Get.showSnackbar(GetSnackBar(
        messageText: Text(
          productName != null && productName.isNotEmpty
              ? '"$productName" ajouté au panier'
              : 'Produit ajouté au panier',
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
      ));
    } catch (e) {
      printLog("AddToCart Error: $e");
      Get.showSnackbar(GetSnackBar(
        messageText: const Text(
          'Impossible d\'ajouter au panier',
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
        icon: const Icon(Icons.error_outline, color: Colors.white),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
      ));
    } finally {
      _isAddingToCart(false);
      _addingProductId.value = '';
    }
  }

  Future deleteAProductFromCart({
    required String productId,
  }) async {
    try {
      await Repository().deleteCartProduct(productId: productId);
      await getCartList(isShowLoading: false);
    } catch (e) {
      printLog("Delete Cart Error: $e");
    }
  }

  Future updateCartProduct({
    required String cartId,
    required int quantity,
    required bool increasing,
  }) async {

    _isIncreasing(increasing);
    _updatingCartId.value = cartId;

    try {
      await Repository().updateCartProduct(
        cartId: cartId,
        quantity: quantity,
      );

      await getCartList(isShowLoading: false);

    } catch (e) {
      printLog("Update Cart Error: $e");
    }

    _updatingCartId.value = "";
  }

  Future getAppliedCouponList() async {
    try {
      final value = await Repository().getAppliedCouponList();

      _appliedCouponList.value = value;
    
    } catch (e, stack) {

      printLog("Coupon Error: $e");
      print(stack);

      _appliedCouponList.value = CouponAppliedList();
    }
  }

  Future applyCouponCode({required String code}) async {
    _isAplyingCoupon(true);

    try {
      await Repository().applyCouponCode(
        couponCode: code,
      );

      await getAppliedCouponList();

    } catch (e) {
      printLog("Apply Coupon Error: $e");
    }

    _isAplyingCoupon(false);
  }
}