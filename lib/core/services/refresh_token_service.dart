import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/authentication/authentication_service.dart';
import 'package:jetwallet/core/services/authentication/models/authorization_union.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/networking/simple_networking.dart';
import 'package:jetwallet/core/services/rsa_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';
import 'package:simple_networking/modules/auth_api/models/refresh/auth_refresh_request_model.dart';

/// Returns [success] if
/// Refreshed token successfully
///
/// Returns [caught] if:
/// 1. Caught 401 error
/// 2. Caught 403 error
///
/// Else [throws] an error
Future<RefreshTokenStatus> refreshToken() async {
  final rsaService = getIt.get<RsaService>();
  final storageService = getIt.get<LocalStorageService>();
  final authInfo = getIt.get<AuthenticationService>().authState;

  try {
    final serverTimeResponse = await getIt
        .get<SNetwork>()
        .simpleNetworking
        .getAuthModule()
        .getServerTime();

    serverTimeResponse.pick(
      onData: (serverTime) async {
        final privateKey = await storageService.getValue(privateKeyKey);
        final refreshToken = authInfo.refreshToken;

        final tokenDateTimeSignatureBase64 = rsaService.sign(
          refreshToken + serverTime.time,
          privateKey!,
        );

        final model = AuthRefreshRequestModel(
          refreshToken: refreshToken,
          requestTime: serverTime.time,
          tokenDateTimeSignatureBase64: tokenDateTimeSignatureBase64,
          lang: intl.localeName,
        );

        final response = await getIt
            .get<SNetwork>()
            .simpleNetworking
            .getAuthModule()
            .postRefresh(model);

        response.pick(
          onData: (data) async {
            print(data);

            await storageService.setString(refreshTokenKey, data.refreshToken);

            getIt.get<AuthenticationService>().updateToken(data.token);
            getIt.get<AuthenticationService>().updateRefreshToken(
                  data.refreshToken,
                );

            /// Recreating a dio object with a token
            getIt.get<SNetwork>().recreateDio();

            return RefreshTokenStatus.success;
          },
          onError: (error) {
            print(error);

            return RefreshTokenStatus.caught;
          },
        );
      },
      onError: (error) {
        print(error);

        return RefreshTokenStatus.caught;
      },
    );

    return RefreshTokenStatus.success;
  } on DioError catch (error) {
    final code = error.response?.statusCode;

    if (code == 401 || code == 403) {
      getIt.get<AppStore>().setAuthStatus(
            const AuthorizationUnion.unauthorized(),
          );

      // remove refreshToken from storage
      await storageService.clearStorage();

      return RefreshTokenStatus.caught;
    } else {
      rethrow;
    }
  }
}
