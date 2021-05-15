import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../router/providers/union/router_union.dart';
import '../../../service/services/authentication/model/authentication_model.dart';
import '../../../service/services/authentication/service/authentication_service.dart';
import '../../services/local_storage_service.dart';
import '../interceptors/interceptor_401.dart';

void addInterceptors(
  Dio dio,
  StateController<RouterUnion> router,
  StateController<AuthenticationModel> authModel,
  GlobalKey<ScaffoldState> routerKey,
  AuthenticationService authenticationService,
  LocalStorageService localStorageService,
) {
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (dioError, handler) async {
        dio.lock();

        if (dioError.response?.statusCode == 401) {
          await interceptor401(
            dio,
            dioError,
            handler,
            router,
            authModel,
            routerKey,
            authenticationService,
            localStorageService,
          );
        } else if (dioError.response?.statusCode == 403) {
          // todo add interceptor403()
        } else {
          handler.reject(dioError);
        }
        
        dio.unlock();
      },
    ),
  );
}
