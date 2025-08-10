import 'package:asset_audit/Pages/AssetPage/model/asset_model.dart';
import 'package:asset_audit/service/api_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as appDio;

class AssetController extends GetxController {
  final ApiService apiService = ApiService();

  RxList<Name> assetList = <Name>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllAssets();
  }

  Future<void> getAllAssets() async {
    final payload = {
      "custom_building": "",
      "custom_floor": "",
      "custom_room": "",
    };

    try {
      isLoading.value = true;
      appDio.Response response = await apiService.postApi(
        'get_asset_list',
        payload,
      );

      if (response.statusCode == 200 ) {
        final assetModel = AssetModel.fromJson(response.data);
        assetList.value = assetModel.message?.name ?? [];
        print('Loaded ${assetList.length} assets');
      } else {
        Get.snackbar('Error', 'API returned status ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
