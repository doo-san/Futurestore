import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:yoori_ecommerce/src/controllers/payment_controller.dart';
import '../models/all_campaign_model.dart' as campaign;
import '../models/all_news_model.dart' as news;
import '../models/video_shopping_model.dart' as video_shopping;
import '../models/all_product_model.dart' as all_product;
import '../models/best_selling_product_model.dart' as best_sell;
import '../models/offer_ending_product_model.dart' as offer_ending;
import '../models/product_by_brand_model.dart' as brand;
import '../models/product_by_category_model.dart' as product;
import '../models/top_shop_model.dart' as top_shop;
import '../models/recent_viewed_product_model.dart' as recent_product;
import '../models/all_shop_model.dart' as all_shop;
import '../models/best_shop_model.dart' as best_shop;
import '../models/flash_sale_model.dart' as flash_sale;
import '../models/today_deal_model.dart' as today_deal;
import '../models/all_category_model.dart';
import '../models/all_category_product_model.dart';
import '../models/all_notifications.dart';
import '../models/campaign_details_model.dart';
import '../models/config_model.dart';
import '../models/coupon_applied_list.dart';
import '../models/coupon_list_model.dart';
import '../models/edit_view_model.dart';
import '../models/favorite_product_model.dart';
import '../models/my_download_model.dart';
import '../models/my_reward_model.dart';
import '../models/my_wallet_model.dart';
import '../models/product_by_campaign_model.dart';
import '../models/home_data_model.dart';
import '../models/order_list_model.dart';
import '../models/product_by_shop_model.dart';
import '../models/product_details_model.dart';
import '../models/profile_data_model.dart';
import '../models/search_product_model.dart';
import '../models/shipping_address_model/get_city_model.dart';
import '../models/shipping_address_model/shipping_address_model.dart';
import '../models/shipping_address_model/state_list_model.dart';
import '../models/track_order_model.dart';
import '../models/user_data_model.dart';
import '../models/visit_shop_model.dart';
import '../models/add_to_cart_list_model.dart';
import '../models/add_to_cart_model.dart';
import '../models/shipping_address_model/country_list_model.dart';
import '../models/forget_password_model.dart';
import '../models/video_shopping_details_model.dart';
import '../screen/auth_screen/otp_screen.dart';
import '../utils/app_tags.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../../config.dart';
import 'package:yoori_ecommerce/src/data/local_data_helper.dart';
import '../models/all_brand_model.dart';
import '../models/chat_seller_model.dart';
import '../models/chat_message_model.dart';
import 'network_service.dart';
import '../models/product_by_category_model.dart';
import 'dart:convert';


Map<String, dynamic> safeJson(dynamic data) {
  if (data == null) return {};
  if (data is Map<String, dynamic>) return data;
  return {};
}

Future<Map<String, dynamic>> safeApiGet(Uri url) async {
  try {
    final response = await NetworkService.client.get(url, headers: {"apiKey": Config.apiKey});

    if (response.statusCode != 200) {
      return {};
    }

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return {};
  } catch (e) {
    print("API ERROR: $e");
    return {};
  }
}

class Repository {
  final NetworkService _service = NetworkService();

  String langCurrCode =
      "lang=${LocalDataHelper().getLangCode() ?? 'fr'}&curr=${LocalDataHelper().getCurrCode() ?? 'XOF'}";


  //firebase auth
  Future<UserDataModel?> postFirebaseAuth({
    String? name,
    String? email,
    String? phone,
    String? image,
    String? providerId,
    String? uid,
  }) async {
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse("${NetworkService.apiUrl}/social-login");

    Map<String, dynamic> data = LocalDataHelper().getCartTrxId() != null
        ? {
      "name": name,
      "email": email.toString(),
      "phone": phone.toString(),
      "image": image,
      "provider": providerId,
      "uid": uid,
      "trx_id": LocalDataHelper().getCartTrxId(),
    }
        : {
      "name": name,
      "email": email.toString(),
      "phone": phone.toString(),
      "image": image,
      "provider": providerId,
      "uid": uid,
    };

    try {
      final response = await NetworkService.client.post(url, headers: headers, body: data);
      print("firebase auth repository: ${jsonDecode(response.body)}");
      print("status code ${response.statusCode}");
      if (response.statusCode == 200) {
        print("block 200");
        var jsonData = jsonDecode(response.body);
        if (jsonData['success']) {
          UserDataModel userDataModel = UserDataModel.fromJson(jsonData);
          LocalDataHelper().saveUserToken(userDataModel.data!.token);
          LocalDataHelper().saveUserAllData(userDataModel);
          return userDataModel;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      printLog("firebase auth error on repository: $e");
      return null;
    }
  }

  //User Phone Login
  Future<bool?> postPhoneLogin({
    String? phoneNumber,
  }) async {
    var headers = {"apiKey": Config.apiKey};
    String? loginOTPScreen = "loginOTPScreen";
    var body = {
      'phone': phoneNumber,
    };
    var url = Uri.parse("${NetworkService.apiUrl}/get-login-otp?$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);

    var data = json.decode(response.body);
    if (data['success']) {
      Get.off(() => OtpScreen(
        phoneNumber: phoneNumber.toString(),
        screen: loginOTPScreen,
      ));
      return data['success'];
    } else {
      showErrorToast(data['message']);
      return false;
    }
  }

  //send Otp Login
  Future<bool?> sendOTPLogin({String? phoneNumber, String? otp}) async {
    var headers = {"apiKey": Config.apiKey};
    var body = otp != null
        ? {
      'phone': phoneNumber,
      'otp': otp,
    }
        : {
      'phone': phoneNumber,
    };

    var url =
    Uri.parse("${NetworkService.apiUrl}/verify-login-otp?$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      UserDataModel userDataModel = UserDataModel.fromJson(data);
      LocalDataHelper().saveUserToken(userDataModel.data!.token);
      LocalDataHelper().saveUserAllData(userDataModel);

      showShortToast(userDataModel.message.toString());
      return userDataModel.success;
    } else {
      showErrorToast(data['message']);
      return false;
    }
  }

  //User Phone Registration
  Future<bool?> postPhoneRegistration(
      {String? firstName, String? lastName, String? phoneNumber}) async {
    var headers = {"apiKey": Config.apiKey};
    String? registrationOTpScreen = "registrationOTpScreen";
    var body = {
      'first_name': firstName,
      'last_name': lastName,
      'phone': phoneNumber,
    };
    printLog(body);
    var url =
    Uri.parse("${NetworkService.apiUrl}/register-by-phone?$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);

    var data = json.decode(response.body);
    if (data['success']) {
      Get.off(OtpScreen(
        phoneNumber: phoneNumber.toString(),
        screen: registrationOTpScreen,
        firstName: firstName,
        lastName: lastName,
      ));
      return data['success'];
    } else {
      showErrorToast(data['message']);
      return false;
    }
  }

  //User Login Registration
  Future<bool?> sendOtpRegistration(
      {String? phoneNumber,
        String? otp,
        String? firstName,
        String? lastName}) async {
    var headers = {"apiKey": Config.apiKey};
    var body = otp != null
        ? {
      'phone': phoneNumber,
      'otp': otp,
      'first_name': firstName,
      'last_name': lastName,
    }
        : {
      'phone': phoneNumber,
      'first_name': firstName,
      'last_name': lastName,
    };
    var url = Uri.parse(
        "${NetworkService.apiUrl}/verify-registration-otp?$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      UserDataModel userDataModel = UserDataModel.fromJson(data);
      LocalDataHelper().saveUserToken(userDataModel.data!.token);
      LocalDataHelper().saveUserAllData(userDataModel);

      showShortToast(userDataModel.message.toString());
      return userDataModel.success;
    } else {
      showErrorToast(data['message']);
      return false;
    }
  }


  //User Login
  Future<bool> loginWithEmailPassword(
      String email, String password, String? trxId) async {
    var headers = {"apiKey": Config.apiKey};
    var body = trxId != null
        ? {
      'email': email,
      'password': password,
      'trx_id': trxId,
    }
        : {
      'email': email,
      'password': password,
    };
    var url = Uri.parse("${NetworkService.apiUrl}/login?$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);

    Map<String, dynamic> data;
    try {
      data = json.decode(response.body);
    } catch (_) {
      showErrorToast("Erreur serveur. Veuillez réessayer.");
      return false;
    }

    printLog("login status: ${response.statusCode}");
    printLog("login body: ${response.body.substring(0, response.body.length.clamp(0, 300))}");

    if (response.statusCode == 200 && data['success'] == true) {
      UserDataModel userDataModel = UserDataModel.fromJson(data);
      final token = userDataModel.data?.token ?? "";
      if (token.isNotEmpty) {
        LocalDataHelper().saveUserToken(token);
      }
      LocalDataHelper().saveUserAllData(userDataModel);
      return true;
    } else {
      final message = data["message"]?.toString() ?? "Identifiants incorrects.";
      showErrorToast(message);
      return false;
    }
  }

  //User Forget Password
  Future postForgetPasswordGetData({String? email}) async {
    var headers = {"apiKey": Config.apiKey};
    var body = {
      'email': email,
    };
    printLog("$email");
    var url = Uri.parse("${NetworkService.apiUrl}/get-verification-link");
    final response = await NetworkService.client.post(url, body: body, headers: headers);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      ForgetPasswordModel forgetPassword = ForgetPasswordModel.fromJson(data);
      LocalDataHelper()
          .saveForgotPasswordCode(forgetPassword.data!.code.toString());
      return forgetPassword;
    } else {
      showErrorToast(data['message']);
    }
  }

  //Confirm OTP
  Future<bool?> postForgetPasswordConfirmOTP(
      {String? email, String? otp}) async {
    var headers = {"apiKey": Config.apiKey};
    var body = {'email': email, 'otp': otp};
    printLog("$email");
    var url = Uri.parse("${NetworkService.apiUrl}/verify-otp");
    final response = await NetworkService.client.post(url, body: body, headers: headers);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      return data['success'];
    } else {
      showErrorToast(data['message']);
      return false;
    }
  }

  //User Forget Password Set
  Future<bool?> postForgetPassword(
      {String? code,
        String? email,
        String? password,
        String? confirmPassword,
        String? otp}) async {
    var headers = {"apiKey": Config.apiKey};
    var body = {
      'code': code,
      'email': email,
      'otp': otp,
      'password': password,
      'password_confirmation': confirmPassword,
    };
    var url =
    Uri.parse("${NetworkService.apiUrl}/create-password?$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      showShortToast(data['message']);
      return data['success'];
    } else {
      showShortToast(data['message']);
      return false;
    }
  }

  //User SignUp
  Future<Map<String, dynamic>> signUp(
      {required String firstName,
        required String lastName,
        required String email,
        required String password,
        required String confirmPassword}) async {
    var headers = {"apiKey": Config.apiKey};
    var body = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
    };
    var url = Uri.parse("${NetworkService.apiUrl}/register?$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);

    printLog("signUp status: ${response.statusCode}");
    printLog("signUp body: ${response.body.substring(0, response.body.length.clamp(0, 300))}");

    Map<String, dynamic> data;
    try {
      data = json.decode(response.body);
    } catch (_) {
      // Réponse non-JSON (ex: erreur HTML du serveur)
      return {'success': false, 'accountCreated': false, 'message': 'Erreur serveur. Veuillez réessayer.'};
    }

    if (response.statusCode == 200 && data['success'] == true) {
      showShortToast(data['message'] ?? 'Inscription réussie', bgColor: Colors.green);
      return {'success': true, 'accountCreated': true, 'message': data['message']};
    }

    // Erreurs de validation (ex: email déjà utilisé, champs invalides)
    if (response.statusCode == 422 || response.statusCode == 400) {
      final message = data['message'] ?? 'Données invalides.';
      showErrorToast(message);
      return {'success': false, 'accountCreated': false, 'message': message};
    }

    // Erreur serveur (500) — le compte peut avoir été créé mais l'email a échoué
    if (response.statusCode == 500 || response.statusCode >= 500) {
      final message = data['message'] ?? 'Compte créé. Connectez-vous directement.';
      showShortToast(message, bgColor: Colors.orange);
      return {'success': false, 'accountCreated': true, 'message': message};
    }

    // Autre cas
    final message = data['message'] ?? 'Erreur inconnue.';
    showErrorToast(message);
    return {'success': false, 'accountCreated': false, 'message': message};
  }

  //User Coupon Send
  Future applyCouponCode({String? couponCode}) async {
    var headers = {"apiKey": Config.apiKey};
    var body = {
      'coupon_code': couponCode,
      'trx_id': LocalDataHelper().getCartTrxId()
    };
    var url = Uri.parse(
        "${NetworkService.apiUrl}/apply-coupon?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      showShortToast(data['message']);
    } else {
      showErrorToast(data['message']);
      return null;
    }
  }

  //User Coupon Delete
  Future postCouponDelete({required int couponId}) async {
    var headers = {"apiKey": Config.apiKey};
    var body = {
      'coupon_id': couponId.toString(),
      'trx_id': LocalDataHelper().getCartTrxId()
    };
    var url = Uri.parse(
        "${NetworkService.apiUrl}/user/delete-coupon?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      showShortToast(data['success']);
    } else {
      showErrorToast(data['success']);
      return null;
    }
  }

  //Product reply Review
  Future postReviewReply({String? reviewId, String? reply}) async {
    var headers = {"apiKey": Config.apiKey};
    var body = {
      'review_id': reviewId.toString(),
      'reply': reply.toString(),
    };
    var url = Uri.parse(
        "${NetworkService.apiUrl}/user/submit-reply?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      showShortToast(data['message']);
    } else {
      showErrorToast(data['message']);
      return null;
    }
  }

  // Review Submit
  Future<bool> postReviewSubmit({
    required String productId,
    required String title,
    required String comment,
    required String rating,
    File? image,
  }) async {
    try {
      var url = Uri.parse(
          "${NetworkService.apiUrl}/user/submit-review?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
      var requestBody = http.MultipartRequest('POST', url);
      requestBody.headers['apiKey'] = Config.apiKey;
      requestBody.fields['product_id'] = productId;
      requestBody.fields['title'] = title;
      requestBody.fields['comment'] = comment;
      requestBody.fields['rating'] = rating;
      if (image != null) {
        var stream = http.ByteStream(image.openRead())..cast();
        var length = await image.length();
        var multipartFile = http.MultipartFile('image', stream, length,
            filename: basename(image.path));
        requestBody.files.add(multipartFile);
      }

      final response = await requestBody.send();
      final result = await http.Response.fromStream(response);
      var data = jsonDecode(result.body);
      if (data['success']) {
        showShortToast(data['message']);
        return data['success'];
      }
      return false;
    } catch (e) {
      throw Exception("$e");
    }
  }

  //Profile Update WithOut Image
  Future<UserDataModel?> postUpdateProfileWithOutImage(
      {required String firstName,
        required String lastName,
        required String phoneNumber,
        required String emailAddress,
        required String? gender,
        required String dob}) async {
    var headers = {"apiKey": Config.apiKey};
    var body = {
      'first_name': firstName.toString(),
      'last_name': lastName.toString(),
      'email': emailAddress.toString(),
      'phone': phoneNumber.toString(),
      'gender': gender.toString(),
      'date_of_birth': dob.toString(),
    };

    printLog(body);
    var url = Uri.parse(
        "${NetworkService.apiUrl}/user/update-profile?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);

    var data = json.decode(response.body);
    printLog("----update profile without image: $data");
    printLog(
        "----update profile:user token: ${LocalDataHelper().getUserToken()}");
    if (response.statusCode == 200) {
      UserDataModel userDataModel = UserDataModel.fromJson(data);

      return userDataModel;
    } else {
      return null;
    }
  }

  //Profile Update With Image
  Future<UserDataModel?> postUpdateProfile(
      {required String firstName,
        required String lastName,
        required String phoneNumber,
        required String emailAddress,
        required File image,
        required String gender,
        required String dob}) async {
    try {
      var url = Uri.parse(
          "${NetworkService.apiUrl}/user/update-profile?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
      var requestBody = http.MultipartRequest('POST', url);
      requestBody.headers['apiKey'] = Config.apiKey;
      requestBody.fields['first_name'] = firstName;
      requestBody.fields['last_name'] = lastName;
      requestBody.fields['email'] = emailAddress;
      requestBody.fields['phone'] = phoneNumber;
      requestBody.fields['gender'] = gender.toString();
      requestBody.fields['date_of_birth'] = dob;
      var stream = http.ByteStream(image.openRead())..cast();
      var length = await image.length();
      var multipartFile = http.MultipartFile('image', stream, length,
          filename: basename(image.path));
      requestBody.files.add(multipartFile);

      printLog(requestBody);
      final response = await requestBody.send();
      final result = await http.Response.fromStream(response);
      var data = jsonDecode(result.body);
      printLog("----update profile: $data");

      if (data['success']) {
        UserDataModel userDataModel = UserDataModel.fromJson(data);
        return userDataModel;
      }
      return null;
    } catch (e) {
      throw Exception("$e");
    }
  }

  //Change Password
  Future<bool> postChangePassword(
      {String? currentPass, String? newPass, String? confirmPass}) async {
    var headers = {"apiKey": Config.apiKey};
    var body = {
      'current_password': currentPass,
      'new_password': newPass,
      'confirm_password': confirmPass,
    };
    var url = Uri.parse(
        "${NetworkService.apiUrl}/user/change-password?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      showErrorToast(data['message']);
      return false;
    }
  }

  //User Find variant(not use)
  Future<UserDataModel?> postFindVariant(String email, String password) async {
    UserDataModel userDataModel;
    var headers = {"apiKey": Config.apiKey};
    var body = {
      'product_id': "productId",
      'color_id': "colorId",
      'attribute_ids': "attributeIds",
    };
    var url = Uri.parse("${NetworkService.apiUrl}/find_variant");
    final response = await NetworkService.client.post(url, body: body, headers: headers);

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      userDataModel = UserDataModel.fromJson(data);
      showShortToast(data['message']);
      return userDataModel;
    } else {
      showErrorToast(data['message']);
      return null;
    }
  }

  //User AtToCart With TrxId
  Future addToCartWithTrxId(
      {String? productId,
        String? quantity,
        String? variantsIds,
        String? variantsNames,
        String? trxId}) async {
    var headers = {"apiKey": Config.apiKey};
    var body = {
      'product_id': productId.toString(),
      'quantity': quantity.toString(),
      'variants_ids': variantsIds.toString(),
      'variants_name': variantsNames.toString(),
      'trx_id': trxId,
    };

    var url = Uri.parse(
        "${NetworkService.apiUrl}/cart-store?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      AddToCartModel addToCartModel = AddToCartModel.fromJson(data);
      LocalDataHelper().saveCartTrxId(addToCartModel.data!.trxId.toString());
      showShortToast(data["message"]);
    } else {
      showErrorToast(data['message']);
    }
  }

  //User AtToCart WithOut TrxId
  Future addToCartWithOutTrxId({
    String? productId,
    String? quantity,
    String? variantsIds,
    String? variantsNames,
  }) async {
    var headers = {"apiKey": Config.apiKey};
    var body = {
      'product_id': productId.toString(),
      'quantity': quantity.toString(),
      'variants_ids': variantsIds.toString(),
      'variants_name': variantsNames.toString(),
    };

    var url = Uri.parse(
        "${NetworkService.apiUrl}/cart-store?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      AddToCartModel addToCartModel = AddToCartModel.fromJson(data);
      LocalDataHelper().saveCartTrxId(addToCartModel.data!.trxId.toString());
      showShortToast(data["message"]);
    } else {
      showErrorToast(data['message']);
    }
  }

  // UpdateProduct
  Future<bool> updateCartProduct({
    required String cartId,
    required int quantity,
  }) async {
    var headers = {"apiKey": Config.apiKey};
    var body = {'quantity': quantity.toString()};
    var url = Uri.parse("${NetworkService.apiUrl}/cart-update/$cartId");
    final response = await NetworkService.client.post(url, body: body, headers: headers);

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      showShortToast(data["message"]);
      return data["success"];
    } else {
      showErrorToast(data['message']);
      return data['success'];
    }
  }

  //User Create Address
  Future postCreateAddress({
    required String name,
    required String email,
    required String phoneNo,
    required int countryId,
    required int stateId,
    required int cityId,
    required String postalCode,
    required String address,
  }) async {
    var headers = {"apiKey": Config.apiKey};
    var bodyData = {
      'name': name.toString(),
      'email': email.toString(),
      'phone_no': phoneNo.toString(),
      'country_id': countryId.toString(),
      'state_id': stateId.toString(),
      'city_id': cityId.toString(),
      'postal_code': postalCode.toString(),
      'address': address.toString()
    };
    var url = Uri.parse(
        "${NetworkService.apiUrl}/user/shipping-addresses?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.post(url, body: bodyData, headers: headers);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      showShortToast(data["message"]);
    } else {
      showErrorToast(data['message']);
    }
  }

  //User Edit Address
  Future updateEditAddress({
    required String name,
    required String email,
    required String phoneNo,
    required int countryId,
    required int stateId,
    required int cityId,
    required String postalCode,
    required String address,
    required int addressId,
  }) async {
    var headers = {"apiKey": Config.apiKey};
    var bodyData = {
      'name': name.toString(),
      'email': email.toString(),
      'phone_no': phoneNo.toString(),
      'country_id': countryId.toString(),
      'state_id': stateId.toString(),
      'city_id': cityId.toString(),
      'postal_code': postalCode.toString(),
      'address': address.toString()
    };
    var url = Uri.parse(
        "${NetworkService.apiUrl}/user/shipping-addresses/$addressId?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.post(url, body: bodyData, headers: headers);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      showShortToast(data["message"]);
    } else {
      showErrorToast(data['message']);
    }
  }

  //Delete Cart
  Future<bool> deleteCartProduct({String? productId}) async {
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse(
        "${NetworkService.apiUrl}/cart-delete/$productId?$langCurrCode");
    final response = await http.delete(url, headers: headers);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      showShortToast(AppTags.productDeletedFromCart.tr);
      return true;
    } else {
      showErrorToast(data['message']);
      return false;
    }
  }

  //Delete User Address
  Future deleteUserAddress({String? addressId}) async {
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse(
        "${NetworkService.apiUrl}/user/shipping-addresses/$addressId?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await http.delete(url, headers: headers);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      showShortToast(data["message"]);
    } else {
      showErrorToast(data['message']);
    }
  }

  //Profile Data
  Future<EditViewModel> getEditViewAddress(int addressId) async {
    EditViewModel editViewModel;
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse(
        "${NetworkService.apiUrl}/user/shipping-addresses/$addressId/edit?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.get(url, headers: headers);
    var data = json.decode(response.body.toString());
    if (response.statusCode == 200) {
      editViewModel = EditViewModel.fromJson(data);
      return editViewModel;
    } else {
      return EditViewModel.fromJson(data);
    }
  }

  //Cart Item List
  Future<AddToCartListModel> getCartItemList() async {
    try {
      final response = await NetworkService.client.get(
        ApiConstants.getCartItemList,
        headers: {"apiKey": Config.apiKey},
      );

      if (response.statusCode != 200) {
        return AddToCartListModel.empty();
      }

      final decoded = json.decode(response.body);

      if (decoded == null || decoded is! Map<String, dynamic>) {
        return AddToCartListModel.empty();
      }

      if (decoded['data'] == null) {
        return AddToCartListModel.empty();
      }

      return AddToCartListModel.fromJson(safeJson(decoded));

    } catch (e, stack) {

      print("CART REPOSITORY ERROR: $e");
      print(stack);

      /// 🔒 Protection finale
      return AddToCartListModel.empty();
    }
  }

  //Tracking  Order
  Future<TrackingOrderModel?> getTrackingOrder({String? trackId}) async {
    TrackingOrderModel trackingOrderModel;
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse(
        "${NetworkService.apiUrl}/track-order?invoice_no=$trackId&token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.get(url, headers: headers);
    var data = json.decode(response.body);
    printLog(data);
    if (data['success']) {
      trackingOrderModel = TrackingOrderModel.fromJson(data);
      return trackingOrderModel;
    } else {
      return TrackingOrderModel.fromJson(data);
    }
  }

  //Order List
  Future<OrderListModel> getOrderList() async {
    var url =
        "${NetworkService.apiUrl}/orders?token=${LocalDataHelper().getUserToken()}&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return OrderListModel.fromJson(response);
  }

  //Guest Order List
  Future<OrderListModel> getGuestOrderList({String? trxId}) async {
    var url = "${NetworkService.apiUrl}/order-by-trx?trx_id=$trxId";
    final response = await _service.fetchJsonData(url);
    return OrderListModel.fromJson(response);
  }

  //Profile Data
  Future<ProfileDataModel?> getProfileData() async {
    String? token = LocalDataHelper().getUserToken();
    if (token == null) {
      return null;
    }
    var url =
        "${NetworkService.apiUrl}/user/profile?token=$token&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return ProfileDataModel.fromJson(response);
  }

  Future<HomeDataModel> getHomeScreenData() async {
    String? token = LocalDataHelper().getUserToken();
    var url = "${NetworkService.apiUrl}/home-screen?$langCurrCode${token != null ? '&token=$token' : ''}";

    final response = await _service.fetchJsonData(url);

    if (response == null || response is! Map<String, dynamic>) {
      throw Exception('Réponse invalide du serveur (type: ${response?.runtimeType})');
    }

    final model = HomeDataModel.fromJson(response);

    print("✅ HomeDataModel parsé — ${model.data?.length ?? 0} sections");
    model.data?.asMap().forEach((index, section) {
      print("  [$index] sectionType='${section.sectionType}'");
    });

    return model;
  }




  //Config Data
  Future<ConfigModel> getConfigData() async {
    var url = "${NetworkService.apiUrl}/configs?$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return ConfigModel.fromJson(response);
  }



  //Flash Sale
  Future<List<flash_sale.Data>> getFlashSaleProduct({required int page}) async {
    var url =
        "${NetworkService.apiUrl}/get-flash-deals-products?page=$page&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return flash_sale.FlashSaleModel.fromJson(response).data;
  }

  //Best Selling Product
  Future<List<best_sell.Data>> getBestSellingProduct(
      {required int page}) async {
    var url =
        "${NetworkService.apiUrl}/get-best-selling-products?page=$page&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return best_sell.BestSellingProductsModel.fromJson(response).data;
  }

  //Offer Ending Product
  Future<List<offer_ending.Data>> getOfferEndingProduct(
      {required int page}) async {
    var url =
        "${NetworkService.apiUrl}/get-offer-ending-products?page=$page&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return offer_ending.OfferEndingProductsModel.fromJson(response).data;
  }

  //All Product
  Future<List<all_product.Data>> getAllProduct({required int page}) async {
    var url = "${NetworkService.apiUrl}/get-products?page=$page&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return all_product.AllProductModel.fromJson(response).data;
  }

  //All Product
  Future<List<video_shopping.Data>> allVideoShopping(
      {required int page}) async {
    var url =
        "${NetworkService.apiUrl}/video-shopping?page=$page&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return video_shopping.VideoShoppingModel.fromJson(response).data!;
  }

  // //Search Product
  Future<SearchProductModel> getSearchProducts(
      {required String searchKey}) async {
    var url =
        "${NetworkService.apiUrl}/search?key=$searchKey&token=${LocalDataHelper().getUserToken() ?? ''}&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return SearchProductModel.fromJson(response);
  }

  //View Product
  Future<List<recent_product.RecentViewedProductModelData>>
  getRecentViewedProduct({required int page}) async {
    var url =
        "${NetworkService.apiUrl}/viewed-products?page=$page&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return recent_product.RecentViewedProductModel.fromJson(response).data;
  }

  //Today Deal
  Future<List<today_deal.Data>> getTodayDealProduct({required int page}) async {
    var url =
        "${NetworkService.apiUrl}/get-today-deals-products?page=$page&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return today_deal.TodayDealModel.fromJson(response).data;
  }

  //Favorite Product
  Future<FavouriteData?> getFavoriteProduct() async {
    String? token = LocalDataHelper().getUserToken();
    if (token == null) return null;
    var url =
        "${NetworkService.apiUrl}/user/favourite-products?token=$token&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return FavouriteData.fromJson(response);
  }

  //Product By Brand
  Future<List<brand.Data>> getProductByBrand(
      {int? id, required int page}) async {
    var url =
        "${NetworkService.apiUrl}/products-by-brand/$id?page=$page&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return brand.ProductByBrandModel.fromJson(response).data;
  }

  //Product By Shop
  Future<ProductByShopModel> getProductByShop(int id) async {
    ProductByShopModel productByShopModel;
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse(
        "${NetworkService.apiUrl}/products-by-shop/$id?$langCurrCode");
    final response = await NetworkService.client.get(url, headers: headers);
    try {
      var data = json.decode(response.body);
      productByShopModel = ProductByShopModel.fromJson(data);
      return productByShopModel;
    } catch (e) {
      throw Exception(e);
    }
  }

  // ✅ PRODUCTS BY CATEGORY — VERSION CORRECTE
  Future<List<product.CategoryProductData>> getProductsByCategory({

    required int categoryId,
    required int page,

  }) async {

    try {

      final url =
          "${NetworkService.apiUrl}/products-by-category/$categoryId?page=$page&$langCurrCode";

      final response = await _service.fetchJsonData(url);

      print("===== PRODUCTS BY CATEGORY RESPONSE =====");
      print(response);

      if (response == null) {
        print("Response is NULL");
        return [];
      }

      final Map<String, dynamic> jsonResponse =
      Map<String, dynamic>.from(response);

      final model =
      product.ProductByCategoryModel.fromJson(jsonResponse);

      print("Loaded products count: ${model.data.length}");

      return model.data;

    } catch (e) {

      print("ERROR getProductsByCategory: $e");

      return [];

    }

  }




  //Product By Campaign
  Future<ProductByCampaignModel> getProductByCampaign(int id) async {
    ProductByCampaignModel productByCampaignModel;
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse(
        "${NetworkService.apiUrl}/products-by-campaign/$id?$langCurrCode");
    final response = await NetworkService.client.get(url, headers: headers);

    try {
      var data = json.decode(response.body);
      productByCampaignModel = ProductByCampaignModel.fromJson(data);
      return productByCampaignModel;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Nombre de produits par catégorie (pour affichage dans les sous-catégories)
  Future<int> getProductCountByCategory(int categoryId) async {
    try {
      final url =
          "${NetworkService.apiUrl}/products-by-category/$categoryId?page=1&$langCurrCode";
      final response = await _service.fetchJsonData(url);
      if (response == null) return 0;
      final jsonResponse = Map<String, dynamic>.from(response);
      // Cas 1 : data est une liste directe
      if (jsonResponse['data'] is List) {
        final list = jsonResponse['data'] as List;
        // Essayer de lire le total depuis metadata si disponible
        final total = jsonResponse['total'] ?? jsonResponse['meta']?['total'];
        if (total != null) return (total as num).toInt();
        return list.length;
      }
      // Cas 2 : data est un objet paginé {total, data: [...]}
      if (jsonResponse['data'] is Map) {
        final dataMap = jsonResponse['data'] as Map;
        final total = dataMap['total'];
        if (total != null) return (total as num).toInt();
        final items = dataMap['data'];
        if (items is List) return items.length;
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }

  //All Category
  Future<AllCategoryModel?> getAllCategory({int page = 1}) async {
    var url = "${NetworkService.apiUrl}/category/all?page=$page&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return AllCategoryModel.fromJson(response);
  }

  //All Category Content
  Future<AllCategoryProductModel?> getAllCategoryContent({int page = 1}) async {
    var url = "${NetworkService.apiUrl}/category/all?page=$page&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return AllCategoryProductModel.fromJson(response);
  }

  //All Campaign
  Future<List<campaign.Data>> getAllCampaign({int page = 1}) async {
    var url = "${NetworkService.apiUrl}/get-campaigns?page=$page&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return campaign.AllCampaignModel.fromJson(response).data!;
  }

  //All Brand
  Future<List<Brand>> getAllBrand({int page = 1}) async {
    var url = "${NetworkService.apiUrl}/all-brand?page=$page&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return AllBrandModel.fromJson(response).brands;
  }

  //All News
  Future<List<news.AllNewsDataModel>> getAllNews({int page = 1}) async {
    var url = "${NetworkService.apiUrl}/all-post/?page=$page&$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return news.AllNewsModel.fromJson(response).data;
  }

  //All Shop
  Future<List<all_shop.Data>> getAllShop({int page = 1}) async {
    String? token = LocalDataHelper().getUserToken();
    var url = "${NetworkService.apiUrl}/all-shop?page=$page&$langCurrCode&token=$token";
    final response = await _service.fetchJsonData(url);
    return all_shop.AllShopModel.fromJson(response).data;
  }

  //All Visit Shop
  Future<VisitShopModel> getVisitShop(int shopId) async {
    VisitShopModel? visitShopModel;
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse("${NetworkService.apiUrl}/shop/$shopId?$langCurrCode");
    final response = await NetworkService.client.get(url, headers: headers);

    var data = json.decode(response.body.toString());
    try {
      visitShopModel = VisitShopModel.fromJson(data);
      return visitShopModel;
        } catch (e) {
      throw Exception(e);
    }
  }

  //All Best Shop
  Future<List<best_shop.BestShopModelData>> getBestShop({int page = 1}) async {
    String? token = LocalDataHelper().getUserToken();
    var url =
        "${NetworkService.apiUrl}/best-shop?page=$page&$langCurrCode&token=$token";
    final response = await _service.fetchJsonData(url);
    return best_shop.BestShopModel.fromJson(response).data;
  }

  //All Top Shop
  Future<List<top_shop.Data>> getTopShop({int page = 1}) async {
    String? token = LocalDataHelper().getUserToken();
    var url =
        "${NetworkService.apiUrl}/top-shop?page=$page&$langCurrCode&token=$token";
    final response = await _service.fetchJsonData(url);
    return top_shop.TopShopModel.fromJson(response).data;
  }

  //Product Details
  Future<ProductDetailsModel> getProductDetails(int productId) async {

    var headers = {
      "apiKey": Config.apiKey,
    };

    var url = Uri.parse(
        "${NetworkService.apiUrl}/product-details/$productId"
            "?token=${LocalDataHelper().getUserToken()}"
            "&$langCurrCode"
    );

    print("===== LOAD PRODUCT DETAILS =====");
    print("PRODUCT ID = $productId");
    print("URL = $url");

    final response = await NetworkService.client.get(url, headers: headers);

    print("STATUS CODE = ${response.statusCode}");
    print("RESPONSE BODY = ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Server error: ${response.statusCode}");
    }

    final data = json.decode(response.body);

    if (data == null) {
      throw Exception("Response is null");
    }

    if (data['success'] != true) {
      throw Exception("API returned success=false");
    }

    return ProductDetailsModel.fromJson(data);

  }


  //Video Shopping Details
  Future<VideoShoppingDetailsModel?> videoShoppingDetails(String slug) async {
    printLog("inside-video_shiopping");
    VideoShoppingDetailsModel videoShoppingDetailsModel;
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse(
        "${NetworkService.apiUrl}/video-shops-details/$slug?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.get(url, headers: headers);
    try {
      var data = json.decode(response.body);
      videoShoppingDetailsModel = VideoShoppingDetailsModel.fromJson(data);
      printLog(
          "Video Type => ${videoShoppingDetailsModel.data!.video!.videoType}");
      return videoShoppingDetailsModel;
    } catch (e) {
      return null;
    }
  }

  //Shipping Address
  Future<ShippingAddressModel> getShippingAddress() async {
    ShippingAddressModel shippingAddressModel;
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse("${NetworkService.apiUrl}/user/shipping-addresses?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.get(url, headers: headers);

    try {
      var data = json.decode(response.body);
      shippingAddressModel = ShippingAddressModel.fromJson(data);
      return shippingAddressModel;
    } catch (e) {
      throw Exception(e);
    }
  }

  // find shipping cost
  Future<Calculations> findShippingCost({required String cityId}) async {
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse(
        "${NetworkService.apiUrl}/find/shipping-cost?city_id=$cityId&trx_id=${LocalDataHelper().getCartTrxId()}&token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.post(url, headers: headers);
    try {
      var data = json.decode(response.body);
      Get.find<PaymentController>().trxId.value= AddToCartListModel.fromJson(data).data!.trxId!;
      return AddToCartListModel.fromJson(data).data!.calculations!;
    } catch (e) {
      throw Exception(e);
    }
  }

  //Country List
  Future<CountryListModel> getCountryList() async {
    CountryListModel countryListModel;
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse("${NetworkService.apiUrl}/get-countries?$langCurrCode");
    final response = await NetworkService.client.get(url, headers: headers);

    try {
      var data = json.decode(response.body);

      countryListModel = CountryListModel.fromJson(data);
      return countryListModel;
    } catch (e) {
      throw Exception(e);
    }
  }

  //State List
  Future<StateListModel> getStateList({int? countryId}) async {
    StateListModel stateListModel;
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse(
        "${NetworkService.apiUrl}/get-states/$countryId?$langCurrCode");
    final response = await NetworkService.client.get(url, headers: headers);
    try {
      var data = json.decode(response.body);
      stateListModel = StateListModel.fromJson(data);
      return stateListModel;
    } catch (e) {
      throw Exception(e);
    }
  }

  //State List
  Future<GetCityModel> getCityList({int? stateId}) async {
    GetCityModel getCitisModel;
    var headers = {"apiKey": Config.apiKey};
    var url =
    Uri.parse("${NetworkService.apiUrl}/get-cities/$stateId?$langCurrCode");
    final response = await NetworkService.client.get(url, headers: headers);

    printLog(response.body);
    try {
      var data = json.decode(response.body);
      getCitisModel = GetCityModel.fromJson(data);
      return getCitisModel;
    } catch (e) {
      throw Exception(e);
    }
  }

  //isFavourite
  Future<bool> addOrRemoveFromFavoriteList(var productId) async {
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse(
        "${NetworkService.apiUrl}/user/favourite/$productId?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.get(url, headers: headers);
    var data = json.decode(response.body);
    return data["success"];
  }

  //Follow Unfollow
  Future<bool> followOrUnfollowShopList(var shopId) async {
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse(
        "${NetworkService.apiUrl}/user/followed-shop/$shopId?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.get(url, headers: headers);
    var data = json.decode(response.body);
    printLog("===${data["success"]}==");
    return data["success"];
  }

  //isLike and Unlike
  Future getLikeAndUnlike({required int reviewId}) async {
    var headers = {"apiKey": Config.apiKey};
    var body = {
      'review_id': reviewId.toString(),
    };
    var url = Uri.parse(
        "${NetworkService.apiUrl}/user/like-unlike-review?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
    } else {
      return null;
    }
  }

  //Campaign Details
  Future<CampaignDetailsModel?> getCampaignDetails(int campaignId) async {
    var url =
        "${NetworkService.apiUrl}/campaign-details/$campaignId?$langCurrCode";
    final response = await _service.fetchJsonData(url);
    return CampaignDetailsModel.fromJson(response);
  }

  //Coupon list
  Future<CouponAppliedList> getAppliedCouponList() async {
    try {

      final response = await NetworkService.client.get(
        Uri.parse(ApiConstants.getAppliedCoupon.toString()),
        headers: {"apiKey": Config.apiKey},
      );

      if (response.statusCode != 200) {
        return CouponAppliedList.empty();
      }

      final data = jsonDecode(response.body);

      if (data == null || data is! Map<String, dynamic>) {
        return CouponAppliedList.empty();
      }

      return CouponAppliedList.fromJson(data);

    } catch (e) {

      print("COUPON ERROR: $e");

      return CouponAppliedList.empty();
    }
  }

  //Voucher list
  Future<CouponListModel?> getVoucherList() async {
    CouponListModel couponListModel;
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse(
        "${NetworkService.apiUrl}/coupons?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.get(url, headers: headers);
    var data = json.decode(response.body.toString());
    if (response.statusCode == 200) {
      couponListModel = CouponListModel.fromJson(data);
      return couponListModel;
    } else {
      return null;
    }
  }

  //LogOut
  Future logOut() async {
    var headers = {"apiKey": Config.apiKey};
    var url = Uri.parse(
        "${NetworkService.apiUrl}/user/logout?token=${LocalDataHelper().getUserToken()}&$langCurrCode");
    final response = await NetworkService.client.post(url, headers: headers);
    var data = json.decode(response.body.toString());
    if (response.statusCode == 200) {
      showShortToast(data['message']);
    } else {
      showErrorToast(data['message']);
    }
  }

  //Pdf Downloader(not use)
  Future<void> getPDF() async {
    var headers = {"apiKey": Config.apiKey};
    try {
      final response = await NetworkService.client.get(
          Uri.parse(
              "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"),
          headers: headers);

      if (response.statusCode == 200) {
        showShortToast(response.body);
        return;
      }
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File file = File('$tempPath/hasan.pdf');
      await file.writeAsBytes(response.bodyBytes);
    } catch (e) {
      throw Exception(e);
    }
  }

  // get all notifications
  Future<AllNotifications?> getAllNotifications(int page) async {
    String? token = LocalDataHelper().getUserToken();
    if (token == null) {
      return null;
    } else {
      try {
        String url =
            "${NetworkService.apiUrl}/user/notifications?page=$page&token=$token&$langCurrCode";
        return _service.fetchJsonData(url).then((response) {
          if (response != null) return AllNotifications.fromJson(response);
        }).catchError(
                (err) => printLog('All notification data fetching error: $err'));
      } catch (e) {
        throw Exception("Data not found");
      }
    }
  }

  // My Wallet
  Future<MyWalletModel?> getMyWallet() async {
    String? token = LocalDataHelper().getUserToken();
    if (token == null) {
      return null;
    } else {
      try {
        String url =
            "${NetworkService.apiUrl}/user/my-wallet?token=$token&$langCurrCode";
        return _service.fetchJsonData(url).then((response) {
          printLog("---------getMyWallet: $response");
          if (response != null) return MyWalletModel.fromJson(response);
        }).catchError(
                (err) => printLog('All my wallet data fetching error: $err'));
      } catch (e) {
        throw Exception("Data not found");
      }
    }
  }

  // My Reward
  Future<MyRewardModel?> getMyReward() async {
    String? token = LocalDataHelper().getUserToken();
    if (token == null) {
      return null;
    } else {
      try {
        String url =
            "${NetworkService.apiUrl}/user/my-reward?token=$token";
        return _service.fetchJsonData(url).then((response) {
          printLog("---------getMyReward: $response");
          log("The url is $url");
          if (response != null) return MyRewardModel.fromJson(response);
        }).catchError(
                (err) => printLog('All my reward data fetching error: $err'));
      } catch (e) {
        throw Exception("Data not found");
      }
    }
  }

  // Convert Reward
  Future<bool> postConvertReward({required String reward}) async {
    String? token = LocalDataHelper().getUserToken();
    var headers = {"apiKey": Config.apiKey};
    var body = {
      'converted_reward': reward,
    };
    var url = Uri.parse(
        "${NetworkService.apiUrl}/user/convert-reward?token=$token&$langCurrCode");
    final response = await NetworkService.client.post(url, body: body, headers: headers);

    var data = json.decode(response.body);
    if (data['success']) {
      printLog(data['success']);
      showShortToast(data['message']);
      return true;
    } else {
      showErrorToast(data['message']);
      return false;
    }
  }

  // My Download
  Future<MyDownloadModel?> getMyDownload() async {
    String? token = LocalDataHelper().getUserToken();
    if (token == null) {
      return null;
    } else {
      try {
        String url =
            "${NetworkService.apiUrl}/user/digital-product-order-list?token=$token&$langCurrCode";
        return _service.fetchJsonData(url).then((response) {
          printLog("---------getMyDownload: $response");
          if (response != null) return MyDownloadModel.fromJson(response);
        }).catchError(
                (err) => printLog('All my download data fetching error: $err'));
      } catch (e) {
        throw Exception("Data not found");
      }
    }
  }

  Future<bool?> deleteNotification(int id) async {
    String? token = LocalDataHelper().getUserToken();
    if (token == null) {
      return false;
    } else {
      try {
        String url =
            "${NetworkService.apiUrl}/user/delete-notification/$id?token=${LocalDataHelper().getUserToken()}&$langCurrCode";
        return _service.fetchJsonData(url).then((response) {
          if (response != null) {
            if (response["success"]) return true;
          }
          return false;
        }).catchError(
                (err) => printLog('All notification data fetching error: $err'));
      } catch (e) {
        throw Exception("Data not found");
      }
    }
  }

  Future<bool> deleteAllNotification() async {
    String? token = LocalDataHelper().getUserToken();
    if (token == null) {
      return false;
    } else {
      try {
        String url =
            "${NetworkService.apiUrl}/user/delete-all-notifications?token=${LocalDataHelper().getUserToken()}&$langCurrCode";
        return _service.fetchJsonData(url).then((response) {
          if (response != null) {
            if (response["success"]) return true;
          }
          return false;
        }).catchError(
                (err) => printLog('All notification data fetching error: $err'));
      } catch (e) {
        throw Exception("Data not found");
      }
    }
  }

  //Delete Account
  Future<bool> deleteAccount() async {
    String? token = LocalDataHelper().getUserToken();
    if (token == null) {
      return false;
    } else {
      try {
        String url =
            "${NetworkService.apiUrl}/user/delete-account?token=${LocalDataHelper().getUserToken()}&$langCurrCode";
        return _service.fetchJsonData(url).then(
              (response) {
            if (response != null) {
              showShortToast(response["message"]);
              if (response["success"]) return true;
            }
            return false;
          },
        ).catchError((err) => printLog('error: $err'));
      } catch (e) {
        throw Exception("Data not found");
      }
    }
  }

  Future<dynamic> getProductByCategoryItem({int? id, required int page}) async {}

  // ─── Chat ───────────────────────────────────────────────────────────────────

  Future<ChatSellerModel?> getChatSellers() async {
    String? token = LocalDataHelper().getUserToken();
    if (token == null) return null;
    try {
      final url = "${NetworkService.apiUrl}/user/sellers?token=$token&$langCurrCode";
      final response = await _service.fetchJsonData(url);
      if (response != null) return ChatSellerModel.fromJson(response);
    } catch (e) {
      printLog('getChatSellers error: $e');
    }
    return null;
  }

  Future<ChatMessageModel?> getChatMessages({required int chatRoomId}) async {
    String? token = LocalDataHelper().getUserToken();
    if (token == null) return null;
    try {
      final url =
          "${NetworkService.apiUrl}/user/messages?chat_room_id=$chatRoomId&token=$token&$langCurrCode";
      // The backend returns HTTP 400 even on success (bug in responseWithError usage),
      // so we use client.get() directly instead of fetchJsonData() to bypass the status check.
      final response = await NetworkService.client.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'apiKey': Config.apiKey,
        },
      );
      if (response.body.isNotEmpty) {
        final decoded = json.decode(response.body);
        return ChatMessageModel.fromJson(decoded);
      }
    } catch (e) {
      printLog('getChatMessages error: $e');
    }
    return null;
  }

  Future<bool> sendChatMessage({
    required int receiverId,   // seller's user_id
    required String message,
    int? chatRoomId,
  }) async {
    String? token = LocalDataHelper().getUserToken();
    if (token == null) return false;
    try {
      final headers = {"apiKey": Config.apiKey};
      final body = <String, String>{
        'msg': message,           // field name is 'msg', not 'message'
        'receiver_id': receiverId.toString(),
      };
      if (chatRoomId != null && chatRoomId > 0) {
        body['chat_room_id'] = chatRoomId.toString();
      }
      // Token in query string so jwt.verify middleware can find it (same as GET endpoints)
      final url = Uri.parse("${NetworkService.apiUrl}/user/send-message?token=$token&$langCurrCode");
      final response = await NetworkService.client.post(url, headers: headers, body: body);
      final data = json.decode(response.body);
      if (data['success'] == true) return true;
      printLog('sendChatMessage failed: ${data['message']}');
    } catch (e) {
      printLog('sendChatMessage error: $e');
    }
    return false;
  }
}

extension on http.Response {
  Null get data => null;
}

class ApiConstants {

  static Uri get getCartItemList => Uri.parse(
      "${NetworkService.apiUrl}/carts"
          "?token=${LocalDataHelper().getUserToken()}"
          "&lang=${LocalDataHelper().getLangCode() ?? 'fr'}"
          "&curr=${LocalDataHelper().getCurrCode() ?? 'XOF'}"
  );

  static Uri get getAppliedCoupon => Uri.parse(
      "${NetworkService.apiUrl}/applied-coupons"
          "?token=${LocalDataHelper().getUserToken()}"
          "&lang=${LocalDataHelper().getLangCode() ?? 'fr'}"
          "&curr=${LocalDataHelper().getCurrCode() ?? 'XOF'}"
  );

}