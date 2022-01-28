import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void setupImageHeaders(Dio dio, Reader read, [String? token]) {
  dio.options.headers['accept'] = 'text/plain';
  dio.options.headers['Content-Type'] = 'multipart/form-data';
  dio.options.headers['Authorization'] = 'Bearer $token';
}
