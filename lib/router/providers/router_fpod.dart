import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/providers/authentication_model_notipod.dart';
import '../../service_providers.dart';
import '../../shared/services/local_storage_service.dart';
import 'router_stpod.dart';
import 'union/router_union.dart';

final routerFpod = FutureProvider<void>((ref) async {
  final router = ref.watch(routerStpod.notifier);
  final authModel = ref.watch(authenticationModelNotipod.notifier);
  final storageService = ref.watch(localStorageServicePod);

  final token = await storageService.getString(tokenKey);
  final refreshToken = await storageService.getString(refreshTokenKey);

  if (token == null || refreshToken == null) {
    router.state = const Unauthorised();
  } else {
    authModel.updateBothTokens(token, refreshToken);
    router.state = const Authorised();
  }
});
