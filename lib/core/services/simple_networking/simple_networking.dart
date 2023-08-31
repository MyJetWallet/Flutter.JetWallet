import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/add_logger.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/add_proxy.dart';
import 'package:jetwallet/core/services/simple_networking/interceptors/auth_interceptor.dart';
import 'package:jetwallet/core/services/simple_networking/interceptors/guest_interceptor.dart';
import 'package:logger/logger.dart';
import 'package:simple_networking/simple_networking.dart';

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

    authorizedDio = await setupDio();
    imageDio = await setupImageDio();
    unauthorizedDio = await setupDioWithoutInterceptors();

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

Future<Dio> setupDio() async {
  final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  setAuthInterceptor(_dio, isImage: false);
  await addProxy(_dio);
  addLogger(_dio);

  return _dio;
}

Future<Dio> setupImageDio() async {
  final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  setAuthInterceptor(_dio, isImage: true);
  await addProxy(_dio);

  return _dio;
}

Future<Dio> setupDioWithoutInterceptors() async {
  final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  setGuestInterceptor(_dio);
  await addProxy(_dio);
  //addLogger(_dio);

  return _dio;
}
