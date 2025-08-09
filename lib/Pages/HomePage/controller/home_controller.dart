import 'dart:convert';
import 'package:asset_audit/Pages/HomePage/model/audit_model.dart';
import 'package:asset_audit/service/api_service.dart';
import 'package:asset_audit/utils/storage_manager.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final StorageManager appStorage = StorageManager();

  RxBool isLoading = false.obs;

  RxString userMail = ''.obs;

  RxList<Message> auditList = <Message>[].obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    userMail.value = await appStorage.read('mail') ?? '';
    print('Home controller ${userMail.value}');
    fetchAudit();
  }

  fetchAudit() async {
    isLoading.value = true;

    try {
      final response = await apiService.getApi('get_api_audit_filter');

      if (response != null && response['message'] != null) {
        // Parse response to Message list
        List<Message> audits =
            (response['message'] as List)
                .map((json) => Message.fromJson(json))
                .toList();

        // Get logged-in user mail
        print('Logged in user: ${userMail.value}');
        auditList.value =
            audits.where((element) {
              return element.assignedTo != null &&
                  element.assignedTo!.contains(userMail.value);
            }).toList();
        print('Filtered audit list: ${jsonEncode(auditList.value)}');
      } else {
        print('Failed to load audits or no data found.');
      }
    } catch (e) {
      Get.snackbar('Error', 'API error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void getBuilding(String id) async {
    final response = await apiService.getApi('get_lm_building');
  }
}
