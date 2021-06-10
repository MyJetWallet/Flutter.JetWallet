import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/provider/auth_model_notipod.dart';
import '../../router/provider/router_key_pod.dart';
import '../../router/provider/router_stpod.dart';
import '../../router/provider/union/router_union.dart';
import '../../service/services/authentication/model/refresh/auth_refresh_request_model.dart';
import '../../service_providers.dart';
import '../services/local_storage_service.dart';

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
  final routerKey = read(routerKeyPod);
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
      router.state = const Unauthorised();

      Navigator.popUntil(
        routerKey.currentContext!,
        (route) => route.isFirst == true,
      );

      // remove refreshToken from storage
      await storageService.clearStorage();

      return RefreshTokenStatus.caught;
    } else {
      rethrow;
    }
  }
}
