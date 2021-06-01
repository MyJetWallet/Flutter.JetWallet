import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/model/auth_model.dart';
import '../../auth/notifiers/auth_model_notifier.dart';
import '../../router/providers/union/router_union.dart';
import '../../service/services/authentication/service/authentication_service.dart';
import '../services/local_storage_service.dart';
import 'helpers/add_interceptors.dart';
import 'helpers/add_logger.dart';
import 'helpers/setup_headers.dart';

Dio basicDio({
  required StateController<RouterUnion> router,
  required GlobalKey<ScaffoldState> routerKey,
  required AuthModel authModel,
  required AuthModelNotifier authModelNotifier,
  required AuthenticationService authService,
  required LocalStorageService storageService,
}) {
  final _dio = Dio();

  setupHeaders(_dio, authModel.token);

  addLogger(_dio);

  addInterceptors(
    dio: _dio,
    router: router,
    routerKey: routerKey,
    authModel: authModel,
    authModelNotifier: authModelNotifier,
    authService: authService,
    storageService: storageService,
  );

  return _dio;
}
