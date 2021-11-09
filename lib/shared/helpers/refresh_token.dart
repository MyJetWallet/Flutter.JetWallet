import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../router/provider/router_stpod/router_stpod.dart';
import '../../router/provider/router_stpod/router_union.dart';
import '../../service/services/authentication/model/refresh/auth_refresh_request_model.dart';
import '../providers/service_providers.dart';
import '../services/local_storage_service.dart';
import 'navigate_to_router.dart';

enum RefreshTokenStatus { success, caught }

/// Returns [success] if
/// Refreshed token successfully
///
/// Returns [caught] if:
/// 1. Caught 401 error
/// 2. Caught 403 error
///
/// Else [throws] an error
Future<RefreshTokenStatus> refreshToken(Reader read) async {
  final router = read(routerStpod.notifier);
  final authInfo = read(authInfoNotipod);
  final authInfoN = read(authInfoNotipod.notifier);
  final authService = read(authServicePod);
  final storageService = read(localStorageServicePod);
  final rsaService = read(rsaServicePod);

  try {
    final serverTime = await authService.serverTime();
    final privateKey = await storageService.getString(privateKeyKey);
    final refreshToken = authInfo.refreshToken;

    final tokenDateTimeSignatureBase64 = await rsaService.sign(
      refreshToken + serverTime.time,
      privateKey!,
    );

    final model = AuthRefreshRequestModel(
      refreshToken: refreshToken,
      requestTime: serverTime.time,
      tokenDateTimeSignatureBase64: tokenDateTimeSignatureBase64,
    );

    final response = await authService.refresh(model);

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
