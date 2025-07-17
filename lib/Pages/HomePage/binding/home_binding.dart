import 'package:asset_audit/Pages/HomePage/controller/home_controller.dart';
import 'package:asset_audit/service/api_service.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(ApiService());
    Get.put(HomeController());
  }
}
