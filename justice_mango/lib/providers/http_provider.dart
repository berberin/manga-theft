import 'package:dio/dio.dart';

class HttpProvider {
  HttpProvider._();

  static final _dio = Dio();

  static init() async {
    _dio.options.headers['Referer'] = 'http://www.nettruyen.com/';
    _dio.options.headers['Origin'] = 'http://www.nettruyen.com';
    _dio.options.headers['Host'] = 'www.nettruyen.com';
  }

  static Future<Response> get(String url, {dynamic query}) async {
    return await _dio.get(url, queryParameters: query);
  }

  static Future<Response> post(String url, {dynamic data}) async {
    return await _dio.post(url, data: data);
  }
}
