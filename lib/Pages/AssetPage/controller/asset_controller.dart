import 'package:asset_audit/Pages/AssetPage/model/asset_model.dart';
import 'package:asset_audit/service/api_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as appDio;

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
final dio = appDio.Dio();

    try {
      // var headers = {
      //   'Content-Type': 'application/json',
      //   'Accept': 'application/json',
      //   'Authorization': 'Token 0714710f8ddac97:bcb24dd3971feb2',
      // };

      // var response = await dio.post(
      //   'https://icts.amrita.ac.in/api/method/helpdesk.api.doc.get_asset_list',
      //   options: appDio.Options(headers: headers),
      // );
// var data = '''''';

      var response = await apiService.getApi('get_asset_list');

      if (response.statusCode == 200) {
        final List<dynamic> list = response.data['message']['name'] ?? [];
        allAssets.value = list.map((e) => AssetModel.fromJson(e)).toList();
        updateDisplayedAssets();
      } else {
        print(response.statusMessage);
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
