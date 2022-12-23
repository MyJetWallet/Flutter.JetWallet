import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/add_logger.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/add_proxy.dart';
import 'package:jetwallet/core/services/simple_networking/interceptors/auth_interceptor.dart';
import 'package:jetwallet/core/services/simple_networking/interceptors/guest_interceptor.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/simple_networking.dart';

late SimpleNetworking sNetwork;

class SNetwork {
  static final _logger = Logger('SNetwork');

  late Dio authorizedDio;
  late Dio imageDio;
  late Dio unauthorizedDio;

  late SimpleNetworking simpleNetworking;
  late SimpleNetworking simpleImageNetworking;
  late SimpleNetworking simpleNetworkingUnathorized;

  late SimpleOptions simpleOptions;

  Future<void> init(String sessionID) async {
    print('SimpleNetworking - init');

    _logger.log(stateFlow, 'SimpleNetworking - init');

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
