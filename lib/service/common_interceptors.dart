import 'package:dio/dio.dart';
class CustomInterceptors extends Interceptor {
  final Map<String , String > headers;

  CustomInterceptors({required this.headers});


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {


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
}