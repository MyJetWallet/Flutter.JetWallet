import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/model/auth_model.dart';
import '../../../auth/notifiers/auth_model_notifier.dart';
import '../../../router/providers/union/router_union.dart';
import '../../../service/services/authentication/model/refresh/auth_refresh_request_model.dart';
import '../../../service/services/authentication/service/authentication_service.dart';
import '../../services/local_storage_service.dart';
import '../helpers/retry_request.dart';

Future<void> interceptor401({
  required Dio dio,
  required DioError dioError,
  required ErrorInterceptorHandler handler,
  required StateController<RouterUnion> router,
  required GlobalKey<ScaffoldState> routerKey,
  required AuthModel authModel,
  required AuthModelNotifier authModelNotifier,
  required AuthenticationService authService,
  required LocalStorageService storageService,
}) async {
  var refreshSuccess = true;

  final refreshRequest = AuthRefreshRequestModel(
    refreshToken: authModel.token,
    requestTime: DateTime.now().toUtc().toString(),
  );

  try {
    final response = await authService.refresh(refreshRequest);

    await storageService.setString(refreshTokenKey, response.refreshToken);

    authModelNotifier.updateToken(response.token);
    authModelNotifier.updateRefreshToken(response.refreshToken);
  } catch (e) {
    refreshSuccess = false;

    router.state = const Unauthorised();

    Navigator.popUntil(
      routerKey.currentContext!,
      (route) => route.isFirst == true,
    );

    // remove refreshToken from storage
    await storageService.clearStorage();
  }

  if (refreshSuccess) {
    try {
      final response = await retryRequest(
        dioError.requestOptions,
        authModel.token,
      );
      handler.resolve(response);
    } catch (e) {
      handler.reject(dioError);
    }
  } else {
    handler.reject(dioError);
  }
}
