import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/add_logger.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/add_proxy.dart';
import 'package:jetwallet/core/services/simple_networking/interceptors/auth_interceptor.dart';
import 'package:jetwallet/core/services/simple_networking/interceptors/guest_interceptor.dart';
import 'package:simple_networking/simple_networking.dart';
import 'package:logger/logger.dart';

late SimpleNetworking sNetwork;

class SNetwork {
  final _logger = getIt.get<SimpleLoggerService>();
  final _loggerValue = 'SimpleNetwork';

  late Dio authorizedDio;
  late Dio imageDio;
  late Dio unauthorizedDio;

  late SimpleNetworking simpleNetworking;
  late SimpleNetworking simpleImageNetworking;
  late SimpleNetworking simpleNetworkingUnathorized;

  late SimpleOptions simpleOptions;

  Future<void> init(String sessionID) async {
    _logger.log(
      level: Level.info,
      place: _loggerValue,
      message: 'Init network service',
    );

    authorizedDio = setupDio();
    imageDio = setupImageDio();
    unauthorizedDio = setupDioWithoutInterceptors();

    simpleNetworking = SimpleNetworking(
      authorizedDio,
      simpleOptions,
      sessionID,
    );

    simpleImageNetworking = SimpleNetworking(
      imageDio,
      simpleOptions,
      sessionID,
    );

    simpleNetworkingUnathorized = SimpleNetworking(
      unauthorizedDio,
      simpleOptions,
      sessionID,
    );

    sNetwork = getIt.get<SNetwork>().simpleNetworking;

    return;
  }
}

Dio setupDio() {
  final _dio = Dio();

  setAuthInterceptor(_dio, isImage: false);
  addProxy(_dio);
  addLogger(_dio);

  return _dio;
}

Dio setupImageDio() {
  final _dio = Dio();

  setAuthInterceptor(_dio, isImage: true);
  addProxy(_dio);

  return _dio;
}

Dio setupDioWithoutInterceptors() {
  final _dio = Dio();

  setGuestInterceptor(_dio);
  addProxy(_dio);
  addLogger(_dio);

  return _dio;
}
