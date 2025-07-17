import 'package:asset_audit/Pages/BarCodePage/controller/barcode_controller.dart';
import 'package:asset_audit/service/api_service.dart';
import 'package:get/get.dart';

class BarcodeBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<BarcodeController>(() => BarcodeController());
  }
}
