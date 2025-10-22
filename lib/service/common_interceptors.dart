import 'dart:io';

import 'package:dio/dio.dart';
class CustomInterceptors extends Interceptor {
  final Map<String , String > headers;

  CustomInterceptors({required this.headers});


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('this is curl ${_curlString(options)}');


    print('REQUEST[${options.method}] => PATH: ${options.path}');

    options.headers.addAll(headers);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
   String _curlString(     RequestOptions  request) {
    String result = '';
    result += "curl --request  ${request.method} '${request.uri}' \\\n";
     request.headers.forEach((k, v) => result += "--header '$k: $v' \\\n");
    final contentType =   request.headers[HttpHeaders.contentTypeHeader]?.toLowerCase();
    if (contentType == null) {
      result = result.substring(0, result.length - 2);
      return result;
    }
    final body = request.data;
      result += "--data-raw '${body}'";
    return result;
  }
}