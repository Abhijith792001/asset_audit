import 'dart:convert';
import 'package:get/get.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/utils/storage_manager.dart';
import 'package:asset_audit/Authentication/model/user_model.dart';

class AuthController extends GetxController {
  final StorageManager appStorage = StorageManager();
  RxBool isLoading = false.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final String _userKey = 'user';

  // Register User
  Future<void> registerUser(String name, String email, String mPin) async {
    try {
      isLoading.value = true;

      final user = UserModel(name: name, email: email, mPin: mPin);
      final userJson = jsonEncode(user.toJson());

      await appStorage.write(_userKey, userJson);

      await appStorage.write('userMail', email);

      currentUser.value = user;
      Get.snackbar('Success', 'User registered successfully');
      Get.offNamed(AppRoutes.loginPage);
    } catch (e) {
      Get.snackbar('Error', 'Failed to register user: $e');
      print('Register Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Load saved user
  Future<void> loadUser() async {
    try {
      final storedData = await appStorage.read(_userKey);
      if (storedData != null) {
        final jsonMap = jsonDecode(storedData);
        currentUser.value = UserModel.fromJson(jsonMap);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user: $e');
      print('Load Error: $e');
    }
  }

  // ✅ Login using MPIN
  Future<void> loginWithMPin(String enteredMPin) async {
    try {
      isLoading.value = true;
      final storedData = await appStorage.read(_userKey);

      if (storedData != null) {
        final jsonMap = jsonDecode(storedData);
        final savedUser = UserModel.fromJson(jsonMap);

        if (savedUser.mPin == enteredMPin) {
          currentUser.value = savedUser;
          Get.snackbar('Login Successful', 'Welcome ${savedUser.name}');
          Get.offNamed(AppRoutes.homePage); // 👈 Redirect to homepage
        } else {
          Get.snackbar('Invalid MPIN', 'Please try again');
        }
      } else {
        Get.snackbar('Error', 'No user registered');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e');
      print('Login Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    await appStorage.delete(_userKey);
    currentUser.value = null;
    Get.snackbar('Logged Out', 'User session cleared');
    Get.offAllNamed(AppRoutes.registrationPage);
  }
}
