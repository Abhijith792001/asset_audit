import 'dart:convert';
import 'package:asset_audit/Authentication/model/user_model.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/utils/storage_manager.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final StorageManager _storage = StorageManager();
  final String _userMail = 'user';
 String? userData = '';

  @override
  void onInit() async {
    super.onInit();
    _initializeApp();
     userData = await _storage.read('mail');
  }

  void _initializeApp() async {
    try {
      FlutterNativeSplash.remove();
      await Future.delayed(const Duration(seconds: 2));

      // print(userData);

      if (userData != null) {
        Get.offAllNamed(AppRoutes.loginPage);
      } else {
        Get.offAllNamed(AppRoutes.registrationPage);
      }
    } catch (e) {
      // print('Error during initialization: $e');
      FlutterNativeSplash.remove();
      Get.offAllNamed(AppRoutes.registrationPage); // fallback
    }
  }
}
