import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/model/auth_model.dart';
import '../../../auth/notifiers/auth_model_notifier.dart';
import '../../../router/providers/union/router_union.dart';
import '../../../service/services/authorization/model/authorization_refresh_request_model.dart';
import '../../../service/services/authorization/service/authorization_service.dart';
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
  required AuthorizationService authorizationService,
  required LocalStorageService localStorageService,
}) async {
  var refreshSuccess = true;

  final refreshRequest = AuthorizationRefreshRequestModel(
    token: authModel.token,
    requestTime: DateTime.now().toUtc().toString(),
  );

  try {
    final response = await authorizationService.refresh(refreshRequest);

    authModelNotifier.updateToken(response.token);
  } catch (e) {
    refreshSuccess = false;

    router.state = const Unauthorised();

    Navigator.popUntil(
      routerKey.currentContext!,
      (route) => route.isFirst == true,
    );

    // remove stored token from storage
    await localStorageService.clearStorage();
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
