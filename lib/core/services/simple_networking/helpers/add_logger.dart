import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:logger/logger.dart';

void addLogger(Dio dio) {
  dio.interceptors.add(
    PrettyDioLogger(
      requestBody: true,
      requestHeader: false,
      logPrint: (object) {
        getIt.get<SimpleLoggerService>().log(
              level: Level.info,
              place: 'Request',
              message: '$object',
            );
      },
    ),
  );
}
