import 'package:dio/dio.dart';
import 'package:jetwallet/core/services/logger_service/simple_http_logger.dart';

void addLogger(Dio dio) {
  dio.interceptors.add(
    //PrettyDioLogger(
    SimpleHTTPLogger(
      requestBody: true,
    ),
  );
}
