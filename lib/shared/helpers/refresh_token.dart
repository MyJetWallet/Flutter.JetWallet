import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/screens/sign_in_up/provider/auth_model_notipod.dart';
import '../../router/provider/router_stpod/router_stpod.dart';
import '../../router/provider/router_stpod/router_union.dart';
import '../../service/services/authentication/model/refresh/auth_refresh_request_model.dart';
import '../providers/other/navigator_key_pod.dart';
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
  final navigatorKey = read(navigatorKeyPod);
  final authModel = read(authModelNotipod);
  final authModelNotifier = read(authModelNotipod.notifier);
  final authService = read(authServicePod);
  final storageService = read(localStorageServicePod);

  try {
    final model = AuthRefreshRequestModel(
      refreshToken: authModel.refreshToken,
      requestTime: DateTime.now().toUtc().toString(),
    );

    final response = await authService.refresh(model);

    await storageService.setString(refreshTokenKey, response.refreshToken);

    authModelNotifier.updateToken(response.token);
    authModelNotifier.updateRefreshToken(response.refreshToken);

    return RefreshTokenStatus.success;
  } on DioError catch (error) {
    final code = error.response?.statusCode;

    if (code == 401 || code == 403) {
      router.state = const Unauthorized();
      
      navigateToRouter(navigatorKey);

      // remove refreshToken from storage
      await storageService.clearStorage();

      return RefreshTokenStatus.caught;
    } else {
      rethrow;
    }
  }
}
