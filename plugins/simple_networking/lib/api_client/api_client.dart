import 'package:dio/dio.dart';
import 'package:simple_networking/helpers/api_errors/bad_network_api_error.dart';
import 'package:simple_networking/helpers/api_errors/internal_server_api_error.dart';
import 'package:simple_networking/helpers/api_errors/unauthorized_api_error.dart';
import 'package:simple_networking/simple_networking.dart';

class ApiClient {
  ApiClient(this.dio, this.options);

  final Dio dio;
  final SimpleOptions options;

  Future<Response> post(
    String path, {
    dynamic data,
  }) async {
    return await dio.post(path, data: data);
  }

  Future<Response> put(
    String path, {
    dynamic data,
  }) async {
    return await dio.put(path, data: data);
  }

  Future<Response> delete(
    String path, {
    dynamic data,
  }) async {
    return await dio.delete(path, data: data);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(
      path,
      queryParameters: queryParameters,
    );
  }
}
