import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoori_ecommerce/src/models/all_notifications.dart';
import 'package:yoori_ecommerce/src/servers/repository.dart';
import 'package:yoori_ecommerce/src/utils/constants.dart';

class AllNotificationsController extends GetxController {
  final _dataAvailable = false.obs;
  final noData = false.obs;
  final _isAllDeleted = false.obs;
  final _toDaysNotifications = <Notifications>[].obs;
  final _othersNotifications = <Notifications>[].obs;
  final _allNotifications = <Notifications>[].obs;
  bool get dataAvailable => _dataAvailable.value;
  List<Notifications> get toDaysNotification => _toDaysNotifications;
  List<Notifications> get othersNotifications => _othersNotifications;
  List<Notifications> get allNotifications => _allNotifications;
  int page = 1;
  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = true.obs;
  var isMoreDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
    paginateTask();
  }

  Future<void> fetchData() {
    return Repository().getAllNotifications(page).then((allNotifications) {
      if (allNotifications != null) {
        noData(allNotifications.data.notifications.isEmpty);
        _allNotifications.addAll(allNotifications.data.notifications);
        _dataAvailable(true);
      } else {
        noData(true);
      }
    }).catchError((error, stackTrace) {
      printLog("Error: $error");
    });
  }

  // For Pagination
  void paginateTask() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (isMoreDataAvailable.value) {
          page++;
          getMoreTask(page);
        }
      }
    });
  }

  Future<void> getMoreTask(int page) async {
    isMoreDataLoading(true);
    Repository().getAllNotifications(page).then((allNotifications) {
      if (allNotifications != null) {
        if (allNotifications.data.notifications.isNotEmpty) {
          // Ajouter à la liste principale affichée par l'écran
          _allNotifications.addAll(allNotifications.data.notifications);
          isMoreDataAvailable(true);
        } else {
          isMoreDataAvailable(false);
        }
      } else {
        isMoreDataAvailable(false);
      }
    }).catchError((error, stackTrace) {
      isMoreDataAvailable(false);
    }).whenComplete(() => isMoreDataLoading(false));
  }

  Future<bool> deleteAllNotifications() async {
    return Repository()
        .deleteAllNotification()
        .then((value) {
          return value;
        })
        .onError(
            (error, stackTrace) { printLog("Error on notification delete."); return false; })
        .whenComplete(() {
          _isAllDeleted.value = true;
          _toDaysNotifications.clear();
          _othersNotifications.clear();
          _allNotifications.clear();
          noData(true);
        });
  }

  void removeNotification(int id) {
    _othersNotifications.removeWhere((element) => element.id == id);
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }
}
