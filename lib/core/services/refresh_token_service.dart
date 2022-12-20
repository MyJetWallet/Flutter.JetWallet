import 'dart:async';

import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/rsa_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
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
}) async {
  final rsaService = getIt.get<RsaService>();
  final storageService = getIt.get<LocalStorageService>();
  final authInfo = getIt.get<AppStore>().authState;

  try {
    final serverTimeResponse = await getIt
        .get<SNetwork>()
        .simpleNetworkingWithoutInterceptor
        .getAuthModule()
        .getServerTime();

    if (serverTimeResponse.data != null) {
      final privateKey = await storageService.getValue(privateKeyKey);
      final refreshToken = authInfo.refreshToken;

      if (privateKey == null) {
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
              .simpleNetworkingWithoutInterceptor
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
          .simpleNetworkingWithoutInterceptor
          .getAuthModule()
          .postRefresh(model);

      if (refreshRequest.hasError) {
        return RefreshTokenStatus.caught;
      }

      if (refreshRequest.data != null) {
        await storageService.setString(
          refreshTokenKey,
          refreshRequest.data!.refreshToken,
        );

        getIt.get<AppStore>().updateAuthState(
              token: refreshRequest.data!.token,
              refreshToken: refreshRequest.data!.refreshToken,
            );

        /// Recreating a dio object with a token
        await getIt.get<SNetwork>().recreateDio();
        getIt<SignalRService>().signalR.setUserToken(
              refreshRequest.data!.token,
            );

        return RefreshTokenStatus.success;
      } else {
        return RefreshTokenStatus.caught;
      }
    } else {
      return RefreshTokenStatus.caught;
    }
  } on DioError catch (error) {
    final code = error.response?.statusCode;

    print('DIOERROR');

    if (code == 401 || code == 403) {
      getIt.get<AppStore>().setAuthStatus(
            const AuthorizationUnion.unauthorized(),
          );

      unawaited(
        getIt
            .get<SNetwork>()
            .simpleNetworkingWithoutInterceptor
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

      // remove refreshToken from storage
      await storageService.clearStorage();

      return RefreshTokenStatus.caught;
    } else {
      rethrow;
    }
  } catch (e) {
    print('CATCH ERROR $e');
    return RefreshTokenStatus.caught;
  }
}
