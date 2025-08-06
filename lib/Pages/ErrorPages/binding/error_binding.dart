import 'package:asset_audit/Pages/ErrorPages/controller/error_controller.dart';
import 'package:get/get.dart';

class ErrorBinding  extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(ErrorController());
  }
}