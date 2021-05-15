import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../router/providers/union/router_union.dart';
import '../../service/services/authentication/model/authentication_model.dart';
import '../../service/services/authentication/service/authentication_service.dart';
import '../services/local_storage_service.dart';
import 'helpers/add_interceptors.dart';
import 'helpers/add_logger.dart';
import 'helpers/setup_headers.dart';

Dio basicDio(
  StateController<RouterUnion> router,
  StateController<AuthenticationModel> authModel,
  GlobalKey<ScaffoldState> routerKey,
  AuthenticationService authenticationService,
  LocalStorageService localStorageService,
) {
  final _dio = Dio();

  setupHeaders(_dio, authModel.state.token);

  addLogger(_dio);

  addInterceptors(
    _dio,
    router,
    authModel,
    routerKey,
    authenticationService,
    localStorageService,
  );

  return _dio;
}
