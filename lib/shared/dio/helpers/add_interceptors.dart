import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/notifiers/authentication_model_notifier.dart';
import '../../../router/providers/union/router_union.dart';
import '../../../service/services/authentication/model/authentication_model.dart';
import '../../../service/services/authentication/service/authentication_service.dart';
import '../../services/local_storage_service.dart';
import '../interceptors/interceptor_401.dart';

void addInterceptors({
  required Dio dio,
  required StateController<RouterUnion> router,
  required GlobalKey<ScaffoldState> routerKey,
  required AuthenticationModel authModel,
  required AuthenticationModelNotifier authModelNotifier,
  required AuthenticationService authenticationService,
  required LocalStorageService localStorageService,
}) {
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (dioError, handler) async {
        dio.lock();

        if (dioError.response?.statusCode == 401) {
          await interceptor401(
            dio: dio,
            dioError: dioError,
            handler: handler,
            router: router,
            routerKey: routerKey,
            authModel: authModel,
            authModelNotifier: authModelNotifier,
            authenticationService: authenticationService,
            localStorageService: localStorageService,
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
