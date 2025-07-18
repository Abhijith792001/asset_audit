import 'package:asset_audit/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  void _initializeApp() async {
    try {
      // Delay native splash for only 0.1 second
      // await Future.delayed(const Duration(milliseconds: 0));

      // Remove native splash screen immediately after
      FlutterNativeSplash.remove();

      // Optional: Keep your own Flutter splash visible for 1 second
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to Home Page
      Get.offAllNamed(AppRoutes.loginPage);
    } catch (e) {
      print('Error during initialization: $e');
      try {
        FlutterNativeSplash.remove();
      } catch (splashError) {
        print('Could not remove native splash: $splashError');
      }
      // Get.offAllNamed(AppRoutes.homePage);
    }
  }
}
