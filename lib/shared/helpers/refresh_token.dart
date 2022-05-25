import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/authentication/model/refresh/auth_refresh_request_model.dart';
import 'package:simple_networking/shared/models/refresh_token_status.dart';

import '../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../router/provider/authorization_stpod/authorization_stpod.dart';
import '../../router/provider/authorization_stpod/authorization_union.dart';
import '../providers/service_providers.dart';
import '../services/local_storage_service.dart';
import 'navigate_to_router.dart';

/// Returns [success] if
/// Refreshed token successfully
///
/// Returns [caught] if:
/// 1. Caught 401 error
/// 2. Caught 403 error
///
/// Else [throws] an error
Future<RefreshTokenStatus> refreshToken(Reader read) async {
  final router = read(authorizationStpod.notifier);
  final authInfo = read(authInfoNotipod);
  final authInfoN = read(authInfoNotipod.notifier);
  final authService = read(authServicePod);
  final storageService = read(localStorageServicePod);
  final rsaService = read(rsaServicePod);
  final intl = read(intlPod);

  try {
    final serverTime = await authService.serverTime(intl.localeName,);
    final privateKey = await storageService.getString(privateKeyKey);
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

    final response = await authService.refresh(model, intl.localeName,);

    await storageService.setString(refreshTokenKey, response.refreshToken);

    authInfoN.updateToken(response.token);
    authInfoN.updateRefreshToken(response.refreshToken);

    return RefreshTokenStatus.success;
  } on DioError catch (error) {
    final code = error.response?.statusCode;

    if (code == 401 || code == 403) {
      router.state = const Unauthorized();

      navigateToRouter(read);

      // remove refreshToken from storage
      await storageService.clearStorage();

      return RefreshTokenStatus.caught;
    } else {
      rethrow;
    }
  }
}
