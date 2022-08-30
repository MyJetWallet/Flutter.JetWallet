import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/add_interceptors.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/add_proxy.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/add_signing.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/setup_headers.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:simple_networking/modules/remote_config/models/remote_config_model.dart';
import 'package:simple_networking/simple_networking.dart';

late SimpleNetworking sNetwork;

class SNetwork {
  late Dio dio;

  late SimpleNetworking simpleNetworking;
  late SimpleOptions simpleOptions;

  Future<void> recreateDio() async {
    dio = setupDio();

    simpleNetworking = SimpleNetworking(
      dio,
      simpleOptions,
    );

    sNetwork = getIt.get<SNetwork>().simpleNetworking;

    return;
  }

  Future<void> init() async {
    dio = setupDio();

    simpleNetworking = SimpleNetworking(
      dio,
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
}

Dio setupDio() {
  final _dio = Dio();

  final authModel = getIt.get<AppStore>().authState;

  print('DIO TOKEN ${authModel.token}');

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
