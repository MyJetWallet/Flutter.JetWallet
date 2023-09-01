import 'dart:async';

import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/rsa_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:logger/logger.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';
import 'package:simple_networking/modules/auth_api/models/refresh/auth_refresh_request_model.dart';
import 'package:simple_networking/modules/logs_api/models/add_log_model.dart';

import 'signal_r/signal_r_service.dart';

/// Returns [success] if
/// Refreshed token successfully
///
/// Returns [caught] if:
/// 1. Caught 401 error
/// 2. Caught 403 error
///
/// Else [throws] an error
Future<RefreshTokenStatus> refreshToken({
  bool isResumed = false,
  bool updateSignalR = true,
}) async {
  final rsaService = getIt.get<RsaService>();
  final storageService = getIt.get<LocalStorageService>();
  final authInfo = getIt.get<AppStore>().authState;

  try {
    final serverTimeResponse = await getIt
        .get<SNetwork>()
        .simpleNetworkingUnathorized
        .getAuthModule()
        .getServerTime();

    if (serverTimeResponse.data != null) {
      final privateKey = await storageService.getValue(privateKeyKey);
      final refreshToken = authInfo.refreshToken;

      if (privateKey == null) {
        getIt.get<SimpleLoggerService>().log(
              level: Level.error,
              place: 'RefreshToken',
              message: 'privateKey is null',
            );

        return RefreshTokenStatus.caught;
      }

      final tokenDateTimeSignatureBase64 = rsaService.sign(
        refreshToken + serverTimeResponse.data!.time,
        privateKey,
      );

      if (isResumed) {
        unawaited(
          getIt
              .get<SNetwork>()
              .simpleNetworkingUnathorized
              .getLogsApiModule()
              .postAddLog(
                AddLogModel(
                  level: 'info',
                  message: 'Updating the token after minimising the app',
                  source: 'AppLifecycleState',
                  process: 'Resumed',
                  token: await storageService.getValue(refreshTokenKey),
                ),
              ),
        );
      }

      final model = AuthRefreshRequestModel(
        refreshToken: refreshToken,
        requestTime: serverTimeResponse.data!.time,
        tokenDateTimeSignatureBase64: tokenDateTimeSignatureBase64,
        lang: intl.localeName,
      );

      final refreshRequest = await getIt
          .get<SNetwork>()
          .simpleNetworkingUnathorized
          .getAuthModule()
          .postRefresh(model);

      if (refreshRequest.hasError) {
        getIt.get<SimpleLoggerService>().log(
          level: Level.error,
          place: 'RefreshToken',
          message:
              '''Refresh request return error: ${refreshRequest.error?.cause}''',
        );

        return RefreshTokenStatus.caught;
      }

      if (refreshRequest.data != null) {
        getIt.get<SimpleLoggerService>().log(
              level: Level.info,
              place: 'RefreshToken',
              message: 'Refresh Successs: ${refreshRequest.data?.toJson()}',
            );

        await storageService.setString(
          refreshTokenKey,
          refreshRequest.data!.refreshToken,
        );

        getIt.get<AppStore>().updateAuthState(
              token: refreshRequest.data!.token,
              refreshToken: refreshRequest.data!.refreshToken,
            );

        /// Recreating a dio object with a token
        await getIt.get<SNetwork>().init(getIt<AppStore>().sessionID);
        if (updateSignalR) {
          await getIt.get<SignalRService>().forceReconnectSignalR();
        }

        //getIt<SignalRService>().signalR.setUserToken(
        //      refreshRequest.data!.token,
        //    );

        return RefreshTokenStatus.success;
      } else {
        getIt.get<SimpleLoggerService>().log(
              level: Level.error,
              place: 'RefreshToken',
              message: 'TOKEN CANT UPDATE Reason: 1',
            );

        return RefreshTokenStatus.caught;
      }
    } else {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'RefreshToken',
            message: 'TOKEN CANT UPDATE Reason: 2',
          );

      return RefreshTokenStatus.caught;
    }
  } on DioError catch (error) {
    final code = error.response?.statusCode;

    getIt.get<SimpleLoggerService>().log(
      level: Level.error,
      place: 'RefreshToken',
      message:
          '''TOKEN CANT UPDATE\nReason: 3\nCode: $code\nMessage: ${error.message}''',
    );

    unawaited(
      getIt
          .get<SNetwork>()
          .simpleNetworkingUnathorized
          .getLogsApiModule()
          .postAddLog(
            AddLogModel(
              level: 'error',
              message: error.message,
              source: 'RefreshToken',
              process: 'DIOERROR',
              token: await storageService.getValue(refreshTokenKey),
            ),
          ),
    );

    if (code == 401 || code == 403) {
      await getIt<LogoutService>().logout(
        'REFRESH_TOKEN',
        callbackAfterSend: () {},
      );

      return RefreshTokenStatus.caught;
    } else {
      rethrow;
    }
  } catch (e) {
    getIt.get<SimpleLoggerService>().log(
          level: Level.error,
          place: 'RefreshToken',
          message: 'TOKEN CANT UPDATE\nReason: 4\nCode: $e',
        );

    return RefreshTokenStatus.caught;
  }
}
