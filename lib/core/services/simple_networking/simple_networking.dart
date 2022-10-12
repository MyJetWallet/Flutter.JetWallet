import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/flavor_service.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/add_interceptors.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/add_logger.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/add_proxy.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/add_signing.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/setup_headers.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/setup_image_headers.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/simple_networking.dart';

late SimpleNetworking sNetwork;

class SNetwork {
  static final _logger = Logger('SNetwork');

  late Dio dio;
  late Dio imageDio;
  late Dio withoutInterceptoreDio;

  late SimpleNetworking simpleImageNetworking;
  late SimpleNetworking simpleNetworking;
  late SimpleNetworking simpleNetworkingWithoutInterceptor;

  late SimpleOptions simpleOptions;

  Future<void> recreateDio() async {
    _logger.log(stateFlow, 'SimpleNetworking - recreateDio');

    dio = setupDio();
    imageDio = setupImageDio();
    withoutInterceptoreDio = setupDioWithoutInterceptors();

    simpleNetworking = SimpleNetworking(
      dio,
      simpleOptions,
    );

    simpleImageNetworking = SimpleNetworking(
      imageDio,
      simpleOptions,
    );

    simpleNetworkingWithoutInterceptor = SimpleNetworking(
      withoutInterceptoreDio,
      simpleOptions,
    );

    sNetwork = getIt.get<SNetwork>().simpleNetworking;

    return;
  }

  Future<void> init() async {
    print('SimpleNetworking - init');

    _logger.log(stateFlow, 'SimpleNetworking - init');

    dio = setupDio();
    imageDio = setupImageDio();
    withoutInterceptoreDio = setupDioWithoutInterceptors();

    simpleNetworking = SimpleNetworking(
      dio,
      simpleOptions,
    );

    simpleImageNetworking = SimpleNetworking(
      imageDio,
      simpleOptions,
    );

    simpleNetworkingWithoutInterceptor = SimpleNetworking(
      withoutInterceptoreDio,
      simpleOptions,
    );

    sNetwork = getIt.get<SNetwork>().simpleNetworking;

    return;
  }

  static SimpleNetworking getPhantomClient() {
    final _dio = setupDioWithoutInterceptors();

    final _client = SimpleNetworking(
      _dio,
      SimpleOptions(),
    );

    return _client;
  }

  static SimpleNetworking getImageClient() {
    final _dio = setupImageDio();

    final _client = SimpleNetworking(
      _dio,
      SimpleOptions(),
    );

    return _client;
  }
}

Dio setupDio() {
  final _dio = Dio();

  final authModel = getIt.get<AppStore>().authState;

  print('SETUP DIO TOKEN ${authModel.token.isNotEmpty}');

  setupHeaders(_dio, authModel.token);

  addSigning(_dio);

  //addLogger(_dio);

  addInterceptors(_dio);

  addProxy(_dio);

  return _dio;
}

Dio setupDioWithoutInterceptors() {
  final _dio = Dio();

  final authModel = getIt.get<AppStore>().authState;

  setupHeaders(_dio, authModel.token);

  //addLogger(_dio);

  addProxy(_dio);

  return _dio;
}

Dio setupImageDio() {
  final _dio = Dio();

  final authModel = getIt.get<AppStore>().authState;

  setupImageHeaders(_dio, authModel.token);

  if (flavorService() == Flavor.dev) {
    addLogger(_dio);
  }

  addInterceptors(_dio);

  addProxy(_dio);

  return _dio;
}
