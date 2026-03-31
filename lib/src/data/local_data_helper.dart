import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yoori_ecommerce/src/models/config_model.dart';
import 'package:yoori_ecommerce/src/models/home_data_model.dart';
import 'package:yoori_ecommerce/src/models/profile_data_model.dart';
import 'package:yoori_ecommerce/src/models/user_data_model.dart';
import 'package:yoori_ecommerce/src/widgets/network_image_checker.dart';


class LocalDataHelper {
  var box = GetStorage();

  Future<void> saveUserAllData(UserDataModel userDataModel) async {
    await box.write('userModel', userDataModel.toJson());
  }

  UserDataModel? getUserAllData() {
    var userDataModel = box.read('userModel');
    return userDataModel != null ? UserDataModel.fromJson(userDataModel) : null;
  }

  void saveUserToken(String userToken) async {
    await box.write('userToken', userToken);
  }


  String? getUserToken() {
    String? getData = box.read("userToken");
    return getData;
  }

  Future<void> saveConfigData(ConfigModel data) async {
    await box.write("config_model", data.toJson());
  }

  ConfigModel getConfigData() {

    final data = box.read("config_model");

    if (data == null) {
      print("⚠️ CONFIG_MODEL NOT FOUND IN LOCAL STORAGE");
      return ConfigModel.fromJson({
        "success": false,
        "data": {}
      });
    }

    if (data is! Map<String, dynamic>) {
      print("⚠️ CONFIG_MODEL INVALID FORMAT");
      return ConfigModel.fromJson({
        "success": false,
        "data": {}
      });
    }

    return ConfigModel.fromJson(data);
  }

  bool isPhoneLoginEnabled() {
    if (getConfigData().data!.addons != null) {
      ConfigModel config = getConfigData();
      for (var addon in config.data!.addons!) {
        if (addon.addonIdentifier == "otp_system") {
          return addon.status;
        }
      }
    }
    return false;
  }

  bool isRefundAddonAvailable() {
    if (getConfigData().data!.addons != null) {
      ConfigModel config = getConfigData();
      for (var addon in config.data!.addons!) {
        if (addon.addonIdentifier == "refund" &&
            addon.status == true &&
            addon.addonData != null) {
          return true;
        }
      }
    }
    return false;
  }

  Widget getRefundIcon(){
    return NetworkImageCheckerWidget(image: getRefundAddon() != null &&
                getRefundAddon()!.addonData != null &&
               getRefundAddon()!.addonData!.sticker != null
            ? getRefundAddon()!.addonData!.sticker!
            : "");
  }

  Addons? getRefundAddon() {
    if (getConfigData().data!.addons != null) {
      ConfigModel config = getConfigData();
      for (var addon in config.data!.addons!) {
        if (addon.addonIdentifier == "refund" && addon.addonData != null) {
          return addon;
        }
      }
    }
    return null;
  }

  void saveCurrency(String currCode) {
    box.write('currCode', currCode);
  }

  String? getCurrCode() {
    String? getData = box.read("currCode");
    return getData;
  }

  void saveLanguageServer(String langCode) {
    box.write('langCode', langCode);
  }

  dynamic getLangCode() {
    var getData = box.read("langCode");
    return getData;
  }

  void saveRememberMail(String mail) {
    box.write('mail', mail);
  }

  dynamic getRememberMail() {
    var getData = box.read("mail");
    return getData;
  }

  void saveRememberPass(String pass) {
    box.write('pass', pass);
  }

  dynamic getRememberPass() {
    var getData = box.read("pass");
    return getData;
  }

  void saveHomeContent(HomeDataModel data) {
    box.write("home_content", data.toJson());
  }

  void clearHomeContent() {
    box.remove("home_content");
  }

  HomeDataModel? getHomeData() {
    Map<String, dynamic>? stringData = box.read("home_content");
    if (stringData != null) {
      HomeDataModel data = HomeDataModel.fromJson(stringData);
      return data;
    }
    return null;
  }

  void addRecentlyViewed({
    required int id,
    required String title,
    required String image,
    required String price,
  }) {
    List<dynamic> list = box.read('recently_viewed') ?? [];
    list.removeWhere((e) => e['id'] == id);
    list.insert(0, {'id': id, 'title': title, 'image': image, 'price': price});
    if (list.length > 10) list = list.sublist(0, 10);
    box.write('recently_viewed', list);
  }

  List<Map<String, dynamic>> getRecentlyViewed() {
    List<dynamic> list = box.read('recently_viewed') ?? [];
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  void saveCartTrxId(String trxId) async {
    await box.write("trxId", trxId);
  }

  String? getCartTrxId() {
    String? getTrxId = box.read("trxId");
    return getTrxId != "" ? getTrxId : null;
  }

  Future saveUser(ProfileDataModel user) async {
    await box.write('user', user);
  }

  void saveForgotPasswordCode(String code) async {
    await box.write('code', code);
  }

  String? getForgotPasswordCode() {
    String? getData = box.read("code");
    return getData;
  }
}
