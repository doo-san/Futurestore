import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'src/bindings/init_bindings.dart';
import 'src/controllers/init_controller.dart';
import 'src/_route/routes.dart';
import 'src/data/data_storage_service.dart';
import 'src/languages/language_translation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initialConfig();
  await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyD7vAFkMRVOiw9fORy7_7ZpAlHYUfAALDY", appId: "1:858468987379:android:7b34f664705fb937012286", messagingSenderId: "858468987379", projectId: "yoori-ecommerce"));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

Future<void> initialConfig() async {
  await Get.putAsync(() => StorageService().init());
} 

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final storage = Get.put(StorageService());
  final initController = Get.put(InitController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: InitBindings(),
          locale: storage.languageCode != null
              ? Locale(storage.languageCode!, storage.countryCode)
              : const Locale('fr', 'FR'),
          translations: AppTranslations(),
          fallbackLocale: const Locale('fr', 'FR'),
          debugShowCheckedModeBanner: false,

          theme: ThemeData(

            primaryColor: const Color(0xFFFF0008),

            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFF0008),
              foregroundColor: Colors.white,
              elevation: 0,
            ),

            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF0008),
              primary: const Color(0xFFFF0008),
            ),

            scaffoldBackgroundColor: Colors.white,

          ),

          initialRoute: Routes.splashScreen,
          getPages: Routes.list,
        );
      },
    );
  }
}