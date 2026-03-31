import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yoori_ecommerce/config.dart';
import 'package:yoori_ecommerce/src/utils/images.dart';
import '../../_route/routes.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/details_screen_controller.dart';
import '../../controllers/dashboard_controller.dart';
import 'package:yoori_ecommerce/src/utils/app_tags.dart';
import '../../data/local_data_helper.dart';
import '../../utils/app_theme_data.dart';
import '../../widgets/button_widget.dart';
import 'package:yoori_ecommerce/src/utils/responsive.dart';
import '../../widgets/loader/loader_widget.dart';
import '../../widgets/login_edit_textform_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ⚠️ IMPORTANT : éviter Get.put dans un screen si possible
  final DashboardController homeScreenController =
  Get.put(DashboardController(), permanent: false);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Obx(
              () => Stack(
            alignment: Alignment.center,
            children: [
              _ui(context),

              // ✅ Correction ici (.value obligatoire)
              authController.isLoggingIn.value
                  ? Positioned(
                height: 50.h,
                width: 50.w,
                child: const LoaderWidget(),
              )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Typage explicite
  Widget _ui(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(height: 30.h),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 180.w,
              height: 150.h,
              child: Image.asset(Images.logo),
            ),
            SizedBox(height: 30.h),
            Text(
              AppTags.welcome.tr,
              style: AppThemeData.welComeTextStyle_24,
            ),
            SizedBox(height: 6.h),
            Text(
              AppTags.loginToContinue.tr,
              style: AppThemeData.titleTextStyle_13,
            )
          ],
        ),
        Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 20.h),

              // EMAIL
              LoginEditTextField(
                myController: authController.emailController,
                keyboardType: TextInputType.text,
                hintText: AppTags.emailAddress.tr,
                fieldIcon: Icons.email,
                myObscureText: false,
              ),

              SizedBox(height: 5.h),

              // PASSWORD
              Obx(
                    () => LoginEditTextField(
                  myController: authController.passwordController,
                  keyboardType: TextInputType.text,
                  hintText: AppTags.password.tr,
                  fieldIcon: Icons.lock,
                  myObscureText: authController.isVisible.value,
                  suffixIcon: InkWell(
                    onTap: authController.isVisibleUpdate,
                    child: Icon(
                      authController.isVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppThemeData.iconColor,
                    ),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.only(right: 30.w, left: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                          () => Row(
                        children: [
                          Checkbox(
                            value: authController.isValue.value,
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                            focusColor:
                            AppThemeData.buttonShadowColor,
                            onChanged: (bool? value) {
                              authController.isValueUpdate(value!);
                            },
                          ),
                          Text(
                            AppTags.rememberMe.tr,
                            style: isMobile(context)
                                ? AppThemeData.categoryTitleTextStyle_12
                                : AppThemeData.categoryTitleTextStyle_9Tab,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(Routes.forgetPassword);
                      },
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          AppTags.forgotPassword.tr,
                          style: isMobile(context)
                              ? AppThemeData.forgotTextStyle_12
                              : AppThemeData.todayDealNewStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: InkWell(
                  onTap: () async {
                    String? trxId =
                    LocalDataHelper().getCartTrxId();

                    // ✅ SUPPRESSION DES "!"
                    authController.loginWithEmailPassword(
                      email:
                      authController.emailController.text,
                      password:
                      authController.passwordController.text,
                      trxId: trxId,
                    );

                    if (authController.isValue.value) {
                      LocalDataHelper().saveRememberMail(
                          authController.emailController.text);
                      LocalDataHelper().saveRememberPass(
                          authController.passwordController.text);
                    } else {
                      LocalDataHelper().box.remove("mail");
                      LocalDataHelper().box.remove("pass");
                    }

                    Get.delete<DetailsPageController>();
                  },
                  child: ButtonWidget(
                      buttonTittle: AppTags.signIn.tr),
                ),
              ),
              SizedBox(height: 30.h),
              // ✅ BACK TO SHOPPING
              Center(
                child: InkWell(
                  onTap: () {
                    Get.offAllNamed(Routes.dashboardScreen);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Images.arrowBack,
                            height: 10.h,
                            width: 10.w,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            AppTags.backToShopping.tr,
                            style: isMobile(context)
                                ? AppThemeData.backToHomeTextStyle_12
                                : AppThemeData.categoryTitleTextStyle_9Tab,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ],
    );
  }
}
