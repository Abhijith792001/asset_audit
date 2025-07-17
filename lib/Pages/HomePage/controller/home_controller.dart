import 'package:asset_audit/Pages/HomePage/model/audit_model.dart';
import 'package:asset_audit/service/api_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  RxList<AuditModel> auditList = <AuditModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAudit();
  }

  void fetchAudit() async{
    final response = await apiService.getApi('get_api_audit_filter');

    if (response != null && response['message'] != null) {
      List<AuditModel> audits =
          (response['message'] as List)
              .map((json) => AuditModel.fromJson(json))
              .toList();
      auditList.value = audits;
    } else {
      print('Failed to load audits or no data found.');
    }
  }
  void getBuilding(String id ) async{
      final response = await apiService.getApi('get_lm_building');
      

  }

  
}
