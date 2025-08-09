import 'package:asset_audit/Pages/AssetPage/controller/asset_controller.dart';
import 'package:get/get.dart';

class AssetBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(AssetController());
  }
}