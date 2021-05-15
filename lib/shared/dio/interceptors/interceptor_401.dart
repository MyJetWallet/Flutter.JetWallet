import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../router/providers/union/router_union.dart';
import '../../../service/services/authentication/model/authentication_model.dart';
import '../../../service/services/authentication/model/authentication_refresh_request_model.dart';
import '../../../service/services/authentication/service/authentication_service.dart';
import '../../services/local_storage_service.dart';
import '../helpers/retry_request.dart';

Future<void> interceptor401(
  Dio dio,
  DioError dioError,
  ErrorInterceptorHandler handler,
  StateController<RouterUnion> router,
  StateController<AuthenticationModel> authModel,
  GlobalKey<ScaffoldState> routerKey,
  AuthenticationService authenticationService,
  LocalStorageService localStorageService,
) async {
  var refreshSuccess = true;

  final refreshModel = AuthenticationRefreshRequestModel(
    refreshToken: authModel.state.refreshToken,
  );

  try {
    final response = await authenticationService.refresh(refreshModel);

    authModel.state = authModel.state.copyWith(
      token: response.token,
      refreshToken: response.refreshToken,
    );
  } catch (e) {
    refreshSuccess = false;

    router.state = const Unauthorised();

    Navigator.popUntil(
      routerKey.currentContext!,
      (route) => route.isFirst == true,
    );

    // remove stored token and refreshToken from storage
    await localStorageService.clearStorage();
  }

  if (refreshSuccess) {
    try {
      final response = await retryRequest(
        dioError.requestOptions,
        authModel.state.token,
      );
      handler.resolve(response);
    } catch (e) {
      handler.reject(dioError);
    }
  } else {
    handler.reject(dioError);
  }
}
