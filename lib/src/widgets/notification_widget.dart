import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../_route/routes.dart';
import '../models/all_notifications.dart';
import '../utils/responsive.dart';

class NotificationWidget extends StatelessWidget {
  final Notifications notification;
  final bool isOtherNotification;
  const NotificationWidget(
      {super.key, required this.notification, this.isOtherNotification = false});

  // Ouvre la commande liée à la notification.
  // Le backend fournit une url du type "get-invoice/{code}".
  void _handleTap() {
    final url = notification.url;
    if (url.contains('get-invoice/')) {
      final code = url.split('get-invoice/').last.trim();
      if (code.isNotEmpty) {
        Get.toNamed(Routes.invoiceScreen, parameters: {'trackingId': code});
      }
    }
  }

  // Icône + couleur choisies selon le contenu de la notification
  // (fonctionne aussi bien en français qu'en anglais).
  _NotifStyle _resolveStyle() {
    final text =
        '${notification.title} ${notification.details}'.toLowerCase();
    if (text.contains('deliver') || text.contains('livr')) {
      return const _NotifStyle(Icons.check_circle_rounded, Color(0xFF2E9E7B));
    }
    if (text.contains('cancel') || text.contains('annul')) {
      return const _NotifStyle(Icons.cancel_rounded, Color(0xFFE53935));
    }
    if (text.contains('on_the_way') ||
        text.contains('on the way') ||
        text.contains('route')) {
      return const _NotifStyle(Icons.local_shipping_rounded, Color(0xFF2F80ED));
    }
    if (text.contains('pick') || text.contains('ramass')) {
      return const _NotifStyle(Icons.inventory_2_rounded, Color(0xFF9B51E0));
    }
    if (text.contains('confirm')) {
      return const _NotifStyle(Icons.verified_rounded, Color(0xFF2F80ED));
    }
    if (text.contains('pending') || text.contains('attente')) {
      return const _NotifStyle(Icons.schedule_rounded, Color(0xFFF2994A));
    }
    return const _NotifStyle(Icons.notifications_rounded, Color(0xFFFF0008));
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle();
    final bool tappable = notification.url.contains('get-invoice/');

    return Padding(
      padding: EdgeInsets.only(bottom: isMobile(context) ? 8.h : 10.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFEEEEEE)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  spreadRadius: 0,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: style.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      style.icon,
                      color: style.color,
                      size: 22.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: isMobile(context) ? 13.5.sp : 11.sp,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF222222),
                                  height: 1.25,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text(
                                isOtherNotification
                                    ? extractDate(notification.createdAt)
                                    : extractTime(notification.createdAt),
                                style: TextStyle(
                                  fontSize: isMobile(context) ? 10.sp : 8.sp,
                                  fontFamily: "Poppins",
                                  color: const Color(0xFFAAAAAA),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          notification.details,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isMobile(context) ? 12.sp : 9.5.sp,
                            fontFamily: "Poppins",
                            color: const Color(0xFF8A8A8A),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (tappable)
                    Padding(
                      padding: EdgeInsets.only(left: 4.w, top: 2.h),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 20.r,
                        color: const Color(0xFFCCCCCC),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String extractTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String extractDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(date);
    return formatted;
  }
}

class _NotifStyle {
  final IconData icon;
  final Color color;
  const _NotifStyle(this.icon, this.color);
}
