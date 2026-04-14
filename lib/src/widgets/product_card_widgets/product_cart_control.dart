import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yoori_ecommerce/config.dart';

import '../../_route/routes.dart';
import '../../controllers/cart_content_controller.dart';
import '../../utils/app_theme_data.dart';
import '../../utils/responsive.dart';

/// Shared reactive cart control used across all product card widgets.
///
/// Behaviour:
///   • Out of stock            → greyed disabled button
///   • groceryCartMode=false   → navigates to details page
///   • Has variants            → navigates to details page (need to pick options)
///   • Not in cart             → red add-to-cart button (with spinner)
///   • Already in cart         → red −/qty/+ stepper (animated)
class ProductCartControl extends StatelessWidget {
  const ProductCartControl({
    super.key,
    required this.productId,
    required this.title,
    required this.minOrderQty,
    required this.currentStock,
    required this.hasVariant,
  });

  final int productId;
  final String title;
  final int minOrderQty;
  final int currentStock;
  final bool hasVariant;

  static const Color _red = AppThemeData.productBoxDecorationColor;
  static const Color _white = Colors.white;

  CartContentController get _cart => Get.find<CartContentController>();

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = currentStock == 0;

    // Disabled state
    if (isOutOfStock) return _disabledBtn(context);

    // Navigate-only states (variants or non-grocery mode)
    if (!Config.groceryCartMode || hasVariant) {
      return _navBtn(context);
    }

    // Reactive cart state
    return Obx(() {
      final cartIndex = _cart.incrementProduct(productId);
      final inCart = cartIndex != -1;
      final isAdding = _cart.isAddingToCart &&
          _cart.addingProductId == productId.toString();

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: inCart
            ? _stepper(context, cartIndex)
            : _addBtn(context, isAdding),
      );
    });
  }

  // ── Disabled (out of stock) ───────────────────────────────────────────────
  Widget _disabledBtn(BuildContext context) => _circle(
        context,
        color: Colors.grey.shade300,
        child: Icon(
          Icons.shopping_cart_outlined,
          size: isMobile(context) ? 15.sp : 13.sp,
          color: Colors.white,
        ),
      );

  // ── Navigate to detail page ───────────────────────────────────────────────
  Widget _navBtn(BuildContext context) => GestureDetector(
        onTap: () => Get.toNamed(
          Routes.detailsPage,
          parameters: {'productId': productId.toString()},
        ),
        child: _circle(
          context,
          color: _red,
          child: Icon(
            Icons.shopping_cart_outlined,
            size: isMobile(context) ? 15.sp : 13.sp,
            color: _white,
          ),
        ),
      );

  // ── Add button ────────────────────────────────────────────────────────────
  Widget _addBtn(BuildContext context, bool isAdding) => GestureDetector(
        key: const ValueKey('add'),
        onTap: isAdding
            ? null
            : () => _cart.addToCart(
                  productId: productId.toString(),
                  quantity: minOrderQty.toString(),
                  variantsIds: '',
                  variantsNames: '',
                  productName: title,
                ),
        child: _circle(
          context,
          color: _red,
          shadow: true,
          child: isAdding
              ? SizedBox(
                  width: 13.r,
                  height: 13.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: _white,
                  ),
                )
              : Icon(
                  Icons.add_shopping_cart,
                  size: isMobile(context) ? 15.sp : 13.sp,
                  color: _white,
                ),
        ),
      );

  // ── +/qty/- stepper ───────────────────────────────────────────────────────
  Widget _stepper(BuildContext context, int cartIndex) {
    final cart = _cart.addToCartListModel.data!.carts![cartIndex];
    final cartId = cart.id.toString();
    final qty = cart.quantity ?? 1;

    return Container(
      key: const ValueKey('stepper'),
      height: isMobile(context) ? 30.h : 26.h,
      decoration: BoxDecoration(
        color: _red.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _red.withValues(alpha: 0.35), width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement / remove
          _stepBtn(
            context,
            icon: Icons.remove,
            isUpdating: _cart.isCartUpdating &&
                _cart.updatingCartId == cartId &&
                !_cart.isIncreasing,
            onTap: () {
              if (minOrderQty < qty) {
                _cart.updateCartProduct(
                  increasing: false,
                  cartId: cartId,
                  quantity: -1,
                );
              } else {
                _cart.deleteAProductFromCart(productId: cartId);
              }
            },
          ),

          // Quantity with animation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Padding(
              key: ValueKey(qty),
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                qty.toString(),
                style: TextStyle(
                  fontSize: isMobile(context) ? 13.sp : 11.sp,
                  fontWeight: FontWeight.bold,
                  color: _red,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),

          // Increment
          _stepBtn(
            context,
            icon: Icons.add,
            isUpdating: _cart.isCartUpdating &&
                _cart.updatingCartId == cartId &&
                _cart.isIncreasing,
            onTap: () {
              if (minOrderQty < currentStock) {
                _cart.updateCartProduct(
                  increasing: true,
                  cartId: cartId,
                  quantity: 1,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _stepBtn(
    BuildContext context, {
    required IconData icon,
    required bool isUpdating,
    required VoidCallback onTap,
  }) =>
      InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: isMobile(context) ? 24.w : 20.w,
          height: isMobile(context) ? 24.h : 20.h,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: _red, shape: BoxShape.circle),
          child: isUpdating
              ? SizedBox(
                  width: 10.r,
                  height: 10.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: _white,
                  ),
                )
              : Icon(icon, size: 13.r, color: _white),
        ),
      );

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _circle(
    BuildContext context, {
    required Color color,
    required Widget child,
    bool shadow = false,
  }) =>
      Container(
        width: isMobile(context) ? 32.w : 28.w,
        height: isMobile(context) ? 32.h : 28.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.45),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: child,
      );
}
