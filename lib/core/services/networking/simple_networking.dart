import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/authentication/authentication_service.dart';
import 'package:jetwallet/core/services/networking/helpers/add_interceptors.dart';
import 'package:jetwallet/core/services/networking/helpers/add_logger.dart';
import 'package:jetwallet/core/services/networking/helpers/add_proxy.dart';
import 'package:jetwallet/core/services/networking/helpers/add_signing.dart';
import 'package:jetwallet/core/services/networking/helpers/setup_headers.dart';
import 'package:simple_networking/simple_networking.dart';

@singleton
class SNetwork {
  final Dio dio = setupDio();

  late SimpleNetworking simpleNetworking;
  late SimpleOptions simpleOptions;

  void recreateDio() {
    final _dio = setupDio();

    simpleNetworking = SimpleNetworking(
      _dio,
      simpleOptions,
    );
  }

  Future<void> init(SimpleOptions options) async {
    simpleOptions = options;

    simpleNetworking = SimpleNetworking(
      dio,
      options,
    );
  }
}

final sNetwork = getIt.get<SNetwork>().simpleNetworking;

Dio setupDio() {
  final _dio = Dio();

  final authModel = getIt.get<AuthenticationService>().authState;

  print('SETUP DIO ${authModel}');

  setupHeaders(_dio, authModel.token);

  addSigning(_dio);

  //addLogger(_dio);

  addInterceptors(_dio);

  addProxy(_dio);

  return _dio;
}
