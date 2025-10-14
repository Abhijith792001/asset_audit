import 'dart:convert';
import 'dart:io'; // for Platform check
import 'package:asset_audit/service/api_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as appDio;
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/utils/storage_manager.dart';
import 'package:asset_audit/Authentication/model/user_model.dart';

class AuthController extends GetxController {
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getUserMailName();
    print('${userMail.value} and ${userName.value}');
  }

  final StorageManager appStorage = StorageManager();
  final ApiService apiService = ApiService();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  RxBool isLoading = false.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final String _userKey = 'user';

  RxString errorMessage = ''.obs;

  RxString userMail = ''.obs;
  RxString userName = ''.obs;

  getUserMailName() async {
    userName.value =
        await appStorage.read('name') == null
            ? ""
            : await appStorage.read('name');
    userMail.value =
        await appStorage.read('mail') == null
            ? ''
            : await appStorage.read('mail');
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


  loginWithMPin(String enteredMPin) async {
    isLoading.value = true;

    try {
      final payload = {"user": userMail.value, "mpin": enteredMPin};
      appDio.Response response = await apiService.postApi(
        'agent_login_with_mpin_login',
        payload,
      );

      print('------------>${response}');
      print('${payload}');
      if (response.data['message']['status'] == 'success') {
        Get.snackbar('Login Successful', 'Welcome ${userName.value}');
        Get.offNamed(AppRoutes.homePage);
      } else if (response.data['message']['status'] == 'error') {
        Get.snackbar('Invalid MPIN', 'Please try again');
      } else {
        print('Something wrong');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  accountChecking(String email) async {
    isLoading.value = true;
    try {
      if (_userKey != null) {
        final payload = {"user": email};

        appDio.Response response = await apiService.postApi(
          'agent_login_with_mpin_and_user',
          payload,
        );
        print(response);

        if (response.data['message']['message'] == "No user found.") {
          return errorMessage.value = 'User not found';
        } else if (response.data['message']['message'] ==
            "Please set MPIN in your website.") {
          Get.offNamed(AppRoutes.errorPage);
          return errorMessage.value = '';
        } else if (response.data['message']['message'] ==
            "User and MPIN found.") {
          Get.snackbar('Success', response.data['message']['message']);

          await appStorage.write(
            'name',
            response.data['message']['agent']['agent_name'],
          );
          await appStorage.write(
            'mail',
            response.data['message']['agent']['user'],
          );
          userName.value = await appStorage.read('name');
          userMail.value = await appStorage.read('mail');
          print('UserName ${userName.value} UserMail ${userMail.value}');
          Get.offAllNamed(AppRoutes.loginPage);
          return errorMessage.value = '';
        }
      }
    } catch (e) {
      Get.snackbar('Error catch', e.toString());
    } finally {
      isLoading.value = false;
      print(userName.value);
    }
  }

  // Logout
  Future<void> logout() async {
    await appStorage.deleteAll();
    Get.snackbar('Logged Out', 'User session cleared');
    Get.offAllNamed(AppRoutes.registrationPage);
  }

  takeDeviceInfo() async {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      print('Brand : ${androidInfo.brand}');
    }
  }
}
