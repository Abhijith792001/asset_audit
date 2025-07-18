import 'package:asset_audit/service/common_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_pack;
import 'package:get/utils.dart';

class ApiService {
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Token 0714710f8ddac97:bcb24dd3971feb2',
  };

  late Dio dio;
  ApiService() {
    dio = Dio();
    dio.interceptors.add(CustomInterceptors(headers: headers));
  }

  getApi(String value) async {
    try {
      Response response = await dio.get(
        'https://icts.amrita.ac.in/api/method/helpdesk.api.doc.$value',
      );

      print('Data Fetched ${response.data}');
      return response.data;
    } catch (e) {
      get_pack.Get.snackbar('Error', 'Failed to fetch ${e.toString()}');
      return null;
    }
  }

  postApi(String value, Map<String, dynamic> data) async {
    try {
      Response response = await dio.post(
        'https://icts.amrita.ac.in/api/method/helpdesk.api.doc.$value',
        data: data,
      );
     return response;
    } catch (e) {
      Get.snackbar('Error', "Api response is not working ${e.toString()}");
    }
  }
}
