import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

void addLogger(Dio dio) {
  dio.interceptors.add(
    PrettyDioLogger(
      requestBody: true,
      requestHeader: false,
    ),
  );
}
