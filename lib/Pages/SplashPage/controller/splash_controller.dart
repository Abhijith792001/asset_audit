import 'dart:convert';
import 'package:asset_audit/Authentication/model/user_model.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/utils/storage_manager.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final StorageManager _storage = StorageManager();
  final String _userMail = 'user';

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  void _initializeApp() async {
    try {
      FlutterNativeSplash.remove();
      await Future.delayed(const Duration(seconds: 2));

      final userData = await _storage.read('mail');

      if (userData != null) {
        final userJson = jsonDecode(userData);
        final user = UserModel.fromJson(userJson);

        if (user.mPin != null && user.mPin!.isNotEmpty) {
          // User has mPin, go to mPin login page
          Get.offAllNamed(AppRoutes.loginPage);
        } else {
          // User exists but no mPin, go to normal login
          Get.offAllNamed(AppRoutes.loginPage);
        }
      } else {
        // No user found, go to registration page
        Get.offAllNamed(AppRoutes.registrationPage);
      }
    } catch (e) {
      print('Error during initialization: $e');
      FlutterNativeSplash.remove();
      Get.offAllNamed(AppRoutes.registrationPage); // fallback
    }
  }
}
