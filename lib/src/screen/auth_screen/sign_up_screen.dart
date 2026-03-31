import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoori_ecommerce/src/utils/images.dart';
import '../../_route/routes.dart';
import '../../controllers/auth_controller.dart';
import 'package:yoori_ecommerce/src/utils/app_tags.dart';
import '../../utils/app_theme_data.dart';
import '../../widgets/button_widget.dart';
import 'package:yoori_ecommerce/src/utils/responsive.dart';
import '../../widgets/loader/loader_widget.dart';
import '../../widgets/login_edit_textform_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _ui(context),
            Obx(() => authController.isLoggingIn.value
                ? const Positioned(
              height: 50,
              width: 50,
              child: LoaderWidget(),
            )
                : const SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget _ui(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(height: 40.h),

        // LOGO + TITRE
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 180.w,
              height: 150.h,
              child: Image.asset(Images.logo),
            ),
            SizedBox(height: 15.h),
            Text(
              AppTags.welcome.tr,
              style: AppThemeData.welComeTextStyle_24,
            ),
            SizedBox(height: 6.h),
            Text(
              AppTags.signUpToContinue.tr,
              style: AppThemeData.titleTextStyle_13,
            )
          ],
        ),

        // FORMULAIRE
        Column(
          children: [
            SizedBox(height: 30.h),

            LoginEditTextField(
              myController: authController.firstNameController,
              keyboardType: TextInputType.text,
              hintText: AppTags.firstName.tr,
              fieldIcon: Icons.person,
              myObscureText: false,
            ),

            SizedBox(height: 5.h),

            LoginEditTextField(
              myController: authController.lastNameController,
              keyboardType: TextInputType.text,
              hintText: AppTags.lastName.tr,
              fieldIcon: Icons.person,
              myObscureText: false,
            ),

            SizedBox(height: 5.h),

            LoginEditTextField(
              myController: authController.emailControllers,
              keyboardType: TextInputType.text,
              hintText: AppTags.emailAddress.tr,
              fieldIcon: Icons.email,
              myObscureText: false,
            ),

            SizedBox(height: 5.h),

            // PASSWORD
            Obx(() => LoginEditTextField(
              myController: authController.passwordControllers,
              keyboardType: TextInputType.text,
              hintText: AppTags.password.tr,
              fieldIcon: Icons.lock,
              myObscureText: authController.passwordVisible.value,
              suffixIcon: InkWell(
                onTap: authController.isVisiblePasswordUpdate,
                child: Icon(
                  authController.passwordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AppThemeData.iconColor,
                ),
              ),
            )),

            SizedBox(height: 5.h),

            // CONFIRM PASSWORD
            Obx(() => LoginEditTextField(
              myController:
              authController.confirmPasswordController,
              keyboardType: TextInputType.text,
              hintText: AppTags.confirmPassword.tr,
              fieldIcon: Icons.lock,
              myObscureText:
              authController.confirmPasswordVisible.value,
              suffixIcon: InkWell(
                onTap:
                authController.isVisibleConfirmPasswordUpdate,
                child: Icon(
                  authController.confirmPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AppThemeData.iconColor,
                ),
              ),
            )),

            SizedBox(height: 34.h),

            // BOUTON SIGN UP
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: InkWell(
                onTap: () {
                  authController.signUp(
                    firstName: authController.firstNameController.text,
                    lastName: authController.lastNameController.text,
                    email: authController.emailControllers.text,
                    password: authController.passwordControllers.text,
                    confirmPassword: authController.confirmPasswordController.text,
                  );
                },
                child: ButtonWidget(
                    buttonTittle: AppTags.signUp.tr),
              ),
            ),

            SizedBox(height: 20.h),

            // BACK TO SHOPPING (CORRIGÉ)
            Center(
              child: InkWell(
                onTap: () {
                  Get.toNamed(Routes.dashboardScreen);
                },
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 200,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 3.0),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
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
                              ? AppThemeData
                              .backToHomeTextStyle_12
                              : AppThemeData
                              .categoryTitleTextStyle_9Tab,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // LOGIN LINK
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppTags.iHaveAnAccount.tr,
                  style: AppThemeData.qsTextStyle_12,
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.logIn);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 10.w,
                      top: 10.h,
                      bottom: 10.h,
                    ),
                    child: Text(
                      AppTags.signIn.tr,
                      style: AppThemeData.qsboldTextStyle_12,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ],
    );
  }
}

