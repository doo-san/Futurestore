import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yoori_ecommerce/src/models/user_data_model.dart';
import 'package:yoori_ecommerce/src/servers/repository.dart';
import 'package:yoori_ecommerce/src/data/local_data_helper.dart';
import 'package:yoori_ecommerce/src/utils/constants.dart';
import 'package:yoori_ecommerce/src/_route/routes.dart';

class AuthController extends GetxController {

  // ================= DEPENDENCIES =================

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final Repository _repository = Repository();
  final box = GetStorage();

  // ================= GLOBAL STATE =================

  final Rxn<User> firebaseUser = Rxn<User>();
  final RxBool isLoggingIn = false.obs;

  final Rxn<GoogleSignInAccount> currentGoogleUser = Rxn<GoogleSignInAccount>();
  final RxBool isGoogleSignInInitialized = false.obs;

  // ================= LOGIN =================

  late TextEditingController emailController;
  late TextEditingController passwordController;

  final RxBool isVisible = true.obs;

  void isVisibleUpdate() {
    isVisible.value = !isVisible.value;
  }

  final RxBool isValue =
      (LocalDataHelper().getRememberPass() != null).obs;

  void isValueUpdate(bool? value) {
    if (value != null) {
      isValue.value = value;
    }
  }

  // ================= SIGN UP =================

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailControllers;
  late TextEditingController passwordControllers;
  late TextEditingController confirmPasswordController;

  final RxBool passwordVisible = true.obs;
  final RxBool confirmPasswordVisible = true.obs;

  void isVisiblePasswordUpdate() {
    passwordVisible.value = !passwordVisible.value;
  }

  void isVisibleConfirmPasswordUpdate() {
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }

  // ================= INIT =================

  @override
  void onInit() {
    super.onInit();

    // Login
    emailController = TextEditingController(
      text: LocalDataHelper().getRememberMail() ?? "",
    );

    passwordController = TextEditingController(
      text: LocalDataHelper().getRememberPass() ?? "",
    );

    // SignUp
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailControllers = TextEditingController();
    passwordControllers = TextEditingController();
    confirmPasswordController = TextEditingController();

    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);

    _initializeGoogleSignIn();
  }

  // ================= AUTH STATE =================

  void _handleAuthChanged(User? user) {
    if (user != null) {
      final currentRoute = Get.currentRoute;
      if (currentRoute != Routes.dashboardScreen) {
        Get.offAllNamed(Routes.dashboardScreen);
      }
    }
  }

  // ================= EMAIL LOGIN =================

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
    String? trxId,
  }) async {
    // Validation
    if (email.trim().isEmpty || password.isEmpty) {
      Get.snackbar("Erreur", "Veuillez remplir tous les champs.",
          backgroundColor: Colors.red.shade100);
      return;
    }

    try {
      isLoggingIn.value = true;

      final success =
          await _repository.loginWithEmailPassword(email, password, trxId);

      if (success) {
        // Rediriger vers le dashboard après connexion réussie
        Get.offAllNamed(Routes.dashboardScreen);
      }
      // Cas échec : le repository affiche déjà le toast d'erreur

    } catch (e) {
      Get.snackbar("Erreur", e.toString());
    } finally {
      isLoggingIn.value = false;
    }
  }

  // ================= SIGN UP =================

  Future<void> signUp({required String firstName, required String lastName, required String email, required String password, required String confirmPassword}) async {
    // Validation
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        emailControllers.text.trim().isEmpty ||
        passwordControllers.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar("Erreur", "Veuillez remplir tous les champs.",
          backgroundColor: Colors.red.shade100);
      return;
    }
    if (passwordControllers.text != confirmPasswordController.text) {
      Get.snackbar("Erreur", "Les mots de passe ne correspondent pas.",
          backgroundColor: Colors.red.shade100);
      return;
    }
    if (!emailControllers.text.contains('@')) {
      Get.snackbar("Erreur", "Adresse email invalide.",
          backgroundColor: Colors.red.shade100);
      return;
    }

    try {
      isLoggingIn.value = true;

      final success = await _repository.signUp(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailControllers.text.trim(),
        password: passwordControllers.text,
        confirmPassword: confirmPasswordController.text,
      );

      if (success) {
        // Réinitialiser les champs
        firstNameController.clear();
        lastNameController.clear();
        emailControllers.clear();
        passwordControllers.clear();
        confirmPasswordController.clear();

        // Rediriger vers la page de connexion
        Get.offNamed(Routes.logIn);
      }

    } catch (e) {
      Get.snackbar("Erreur", e.toString());
    } finally {
      isLoggingIn.value = false;
    }
  }

  // ================= GOOGLE INIT =================

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize(
        serverClientId:
        "858468987379-ulhpemk54i753jdrc4vmff5vl52c8946.apps.googleusercontent.com",
      );
      isGoogleSignInInitialized.value = true;
    } catch (_) {
      isGoogleSignInInitialized.value = false;
    }
  }

  // ================= GOOGLE LOGIN =================

  Future<void> signInWithGoogle() async {
    try {
      isLoggingIn.value = true;

      final account = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      final googleAuth = account.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

    } catch (e) {
      Get.snackbar("Erreur", e.toString());
    } finally {
      isLoggingIn.value = false;
    }
  }

  // ================= FACEBOOK LOGIN =================

  Future<void> facebookLogin() async {
    try {
      isLoggingIn.value = true;

      final loginResult = await FacebookAuth.instance.login();

      final credential = FacebookAuthProvider.credential(
        loginResult.accessToken?.tokenString ?? "",
      );

      await _auth.signInWithCredential(credential);

    } catch (e) {
      Get.snackbar("Erreur", e.toString());
    } finally {
      isLoggingIn.value = false;
    }
  }

  // ================= LOGOUT =================

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();

      box.remove("userToken");
      box.remove("trxId");
      box.remove("userModel");

    } catch (e) {
      Get.snackbar("Erreur", e.toString());
    }
  }

  // ================= CLEANUP =================

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    firstNameController.dispose();
    lastNameController.dispose();
    emailControllers.dispose();
    passwordControllers.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }

  bool get isGoogleSignedIn => currentGoogleUser.value != null;
}

extension on GoogleSignInAuthentication {
  String? get accessToken => null;
}