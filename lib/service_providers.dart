import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth/providers/auth_model_notipod.dart';
import 'router/providers/router_key_pod.dart';
import 'router/providers/router_stpod.dart';
import 'service/services/authentication/service/authentication_service.dart';
import 'service/services/authorization/service/authorization_service.dart';
import 'shared/dio/basic_dio.dart';
import 'shared/dio/dio_without_interceptors.dart';
import 'shared/services/local_storage_service.dart';

final authenticationServicePod = Provider<AuthenticationService>((ref) {
  final authModel = ref.watch(authModelNotipod);

  return AuthenticationService(dioWithoutInterceptors(authModel.token));
});

final authorizationServicePod = Provider<AuthorizationService>((ref) {
  final authModel = ref.watch(authModelNotipod);

  return AuthorizationService(dioWithoutInterceptors(authModel.token));
});

final localStorageServicePod = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final dioPod = Provider<Dio>((ref) {
  final router = ref.watch(routerStpod.notifier);
  final routerKey = ref.watch(routerKeyPod);
  final authModel = ref.watch(authModelNotipod);
  final authModelNotifier = ref.watch(authModelNotipod.notifier);
  final authorizationService = ref.watch(authorizationServicePod);
  final storageService = ref.watch(localStorageServicePod);

  return basicDio(
    router: router,
    routerKey: routerKey,
    authModel: authModel,
    authModelNotifier: authModelNotifier,
    authorizationService: authorizationService,
    localStorageService: storageService,
  );
});
