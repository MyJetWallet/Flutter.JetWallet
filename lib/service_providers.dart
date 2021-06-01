import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth/providers/auth_model_notipod.dart';
import 'router/providers/router_key_pod.dart';
import 'router/providers/router_stpod.dart';
import 'service/services/authentication/service/authentication_service.dart';
import 'service/services/authorization/service/authorization_service.dart';
import 'service/services/blockchain/service/blockchain_service.dart';
import 'service/services/chart/service/chart_service.dart';
import 'service/services/signal_r/service/signal_r_service.dart';
import 'service/services/swap/service/swap_service.dart';
import 'shared/dio/basic_dio.dart';
import 'shared/dio/dio_without_interceptors.dart';
import 'shared/services/local_storage_service.dart';

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

final dioWithoutInterceptorsPod = Provider<Dio>((ref) {
  final authModel = ref.watch(authModelNotipod);

  return dioWithoutInterceptors(authModel.token);
});

final authenticationServicePod = Provider<AuthenticationService>((ref) {
  final dio = ref.watch(dioWithoutInterceptorsPod);

  return AuthenticationService(dio);
});

final authorizationServicePod = Provider<AuthorizationService>((ref) {
  final dio = ref.watch(dioWithoutInterceptorsPod);

  return AuthorizationService(dio);
});

final localStorageServicePod = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final intlPod = ScopedProvider<AppLocalizations>(null);

final signalRServicePod = Provider<SignalRService>((ref) {
  return SignalRService();
});

final blockchainServicePod = Provider<BlockchainService>((ref) {
  final dio = ref.watch(dioPod);

  return BlockchainService(dio);
});

final swapServicePod = Provider<SwapService>((ref) {
  final dio = ref.watch(dioPod);

  return SwapService(dio);
});

final chartServicePod = Provider<ChartService>((ref) {
  final dio = ref.watch(dioPod);

  return ChartService(dio);
});
