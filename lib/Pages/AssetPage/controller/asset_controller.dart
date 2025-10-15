import 'package:asset_audit/Pages/AssetPage/model/asset_model.dart';
import 'package:asset_audit/service/api_service.dart';
import 'package:get/get.dart';

class AssetController extends GetxController {
  var allAssets = <AssetModel>[].obs;
  var assets = <AssetModel>[].obs;
  var isLoading = false.obs;
  var page = 1.obs;
  final int limit = 20;
  var searchQuery = ''.obs;

  ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchAssets();
  }

  Future<void> fetchAssets() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      var response = await apiService.getApi('get_asset_list');

      if (response != null) {
        final List<dynamic> list = response['message']['name'] ?? [];
        allAssets.value = list.map((e) => AssetModel.fromJson(e)).toList();
        updateDisplayedAssets();
      } else {
        print("response is null");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateDisplayedAssets() {
    var filteredAssets =
        allAssets.where((asset) {
          final query = searchQuery.value.toLowerCase();
          return asset.name.toLowerCase().contains(query) ||
              asset.productModel.toLowerCase().contains(query);
        }).toList();

    final int startIndex = (page.value - 1) * limit;
    int endIndex = startIndex + limit;
    if (endIndex > filteredAssets.length) {
      endIndex = filteredAssets.length;
    }

    assets.value = filteredAssets.sublist(startIndex, endIndex);
  }

  void searchAssets(String query) {
    searchQuery.value = query;
    page.value = 1;
    updateDisplayedAssets();
  }

  void nextPage() {
    if ((page.value * limit) < allAssets.length) {
      page.value++;
      updateDisplayedAssets();
    }
  }

  void previousPage() {
    if (page.value > 1) {
      page.value--;
      updateDisplayedAssets();
    }
  }
}
