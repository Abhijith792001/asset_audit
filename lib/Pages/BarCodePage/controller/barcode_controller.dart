import 'package:asset_audit/Pages/BarCodePage/model/asset_model.dart';
import 'package:asset_audit/routes/app_routes.dart';
import 'package:asset_audit/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeController extends GetxController {
  final isFlashOn = false.obs;
  late MobileScannerController scannerController;
  RxBool isLoading = false.obs;
  RxList<AssetModel> assets = <AssetModel>[].obs;
  RxString barcode = ''.obs;

  final ApiService apiService = ApiService();

  @override
  void onInit() {
    scannerController = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    super.onInit();
  }

  void toggleFlash() {
    isFlashOn.value = !isFlashOn.value;
    scannerController.toggleTorch();
  }

  void onBarcodeDetect(BarcodeCapture capture) async{
    final codes = capture.barcodes;
    print('---------------------------------------abhiiiiiiiiiiiiiiiiiiiiii- ${codes}');
    if (codes.isNotEmpty) {
      final code = codes.first.rawValue;
      print(code);
      if (code != null && code != barcode.value) {
        debugPrint('Barcode found: $code');
        barcode.value = code;
        print(code);
        await getAsset(code);
        Get.toNamed(AppRoutes.assetViewPage);

        // getAsset(barcode.value).then((_) {
        //   if (assets.isNotEmpty) {
        //     Get.offNamed(AppRoutes.assetViewPage);
        //   }
        // });
      }
    }
  }

getAsset(String code) async {
    try {
      isLoading.value = true;
      final response = await apiService.getApi('get_one?id=$code');
      print("${response}----------------->");

      if (response['message'] != null) {
      final asset = [AssetModel.fromJson(response['message'])];
      assets.value = asset;
      print("${assets.value}-------------> asset value");

      } else {
        Get.snackbar(
          'Not Found',
          'No asset found for barcode ${barcode.value}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error',
        'Failed to fetch asset: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}
