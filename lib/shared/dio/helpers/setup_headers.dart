import 'package:dio/dio.dart';

void setupHeaders(Dio dio, [String? token]) {
  dio.options.headers['accept'] = 'application/json';
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Authorization'] = 'Bearer $token';
}
