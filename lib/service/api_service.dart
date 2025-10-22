import 'dart:convert';

import 'package:asset_audit/service/common_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' as get_pack;
import 'package:get/utils.dart';

class ApiService {
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': dotenv.env['API_TOKEN']!,
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

  postApi(String value, dynamic data) async {
    try {
      Response response = await dio.post(
        'https://icts.amrita.ac.in/api/method/helpdesk.api.doc.$value',
        data: json.encode(data),
      );
      return response;
    } catch (e) {
      Get.snackbar(
        'Error',
        'API response failed: ',
        snackPosition: get_pack.SnackPosition.TOP,
        backgroundColor: Color(0xFFE53935),
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 8,
        icon: Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    }
  }
}
