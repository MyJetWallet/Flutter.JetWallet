import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'helpers/add_logger.dart';
import 'helpers/add_proxy.dart';
import 'helpers/setup_headers.dart';

Dio dioWithoutInterceptors(Reader read) {
  final _dio = Dio();

  setupHeaders(_dio, read);

  addLogger(_dio);

  addProxy(_dio, read);

  return _dio;
}
