import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:simple_networking/api_client/api_client.dart';
import 'package:simple_networking/config/options.dart';
import 'package:simple_networking/core/simple_networking_impl.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';
import 'package:simple_networking/modules/auth_api/repository/auth_api_repository.dart';
import 'package:simple_networking/modules/candles_api/repository/candles_api_repository.dart';
import 'package:simple_networking/modules/logs_api/repository/logs_api_repository.dart';
import 'package:simple_networking/modules/remote_config/repository/remote_config_repository.dart';
import 'package:simple_networking/modules/signal_r/signal_r.dart';
import 'package:simple_networking/modules/validation_api/repository/validation_api_repository.dart';
import 'package:simple_networking/modules/wallet_api/repository/wallet_api_repository.dart';

SimpleNetworking initSimpleNetworking(Dio dio, [SimpleOptions? options]) =>
    SimpleNetworkingImpl(
      dio,
      options,
    );

abstract class SimpleNetworking {
  factory SimpleNetworking(
    Dio dio, [
    SimpleOptions? options,
  ]) {
    return initSimpleNetworking(
      dio,
      options,
    );
  }

  /// Options
  late SimpleOptions options;

  /// Main DIO instance to make requests
  late Dio dio;

  /// Api Client
  late ApiClient apiClient;

  void updateDio(Dio updatedDio);

  /// SignalR Module
  // ignore: long-parameter-list
  SignalRModule getSignalRModule(
    Future<RefreshTokenStatus> Function() refreshToken,
    BaseClient signalRClient,
    String token,
    String localeName,
    String deviceUid,
  );

  /// Auth API Module
  AuthApiRepository getAuthModule();

  /// Wallet API Module
  WalletApiRepository getWalletModule();

  /// Validation API Module
  ValidationApiRepository getValidationModule();

  /// Candles API Module
  CandlesApiRepository getCandlesModule();

  /// Candles API Module
  RemoteConfigRepository getRemoteConfigModule();

  /// Logs API Module
  LogsApiRepository getLogsApiModule();
}
