import 'package:dio/dio.dart';

import 'helpers/add_logger.dart';
import 'helpers/setup_headers.dart';

Dio dioWithoutInterceptors() {
  final _dio = Dio();

  setupHeaders(_dio);

  addLogger(_dio);

  return _dio;
}
