import 'package:dio/dio.dart';

abstract class HttpProvider {
  final dio = Dio();

  void init();

  Future<Response> get(String url, {dynamic query}) async {
    return await dio.get(url, queryParameters: query);
  }

  Future<Response> post(String url, {dynamic data}) async {
    return await dio.post(url, data: data);
  }
}
