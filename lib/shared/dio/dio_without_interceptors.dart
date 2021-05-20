import 'package:dio/dio.dart';

import 'helpers/add_logger.dart';
import 'helpers/setup_headers.dart';

Dio dioWithoutInterceptors(String token) {
  final _dio = Dio();

  setupHeaders(_dio, token);

  addLogger(_dio);

  return _dio;
}
