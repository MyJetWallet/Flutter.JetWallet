import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../router/providers/router_stpod.dart';
import '../../../../service_providers.dart';
import '../notifiers/logout_notifier/logout_notifier.dart';
import '../notifiers/logout_notifier/union/logout_union.dart';

final logoutNotipod =
    StateNotifierProvider<LogoutNotifier, LogoutUnion>((ref) {
  final router = ref.watch(routerStpod);
  final authorizationService = ref.watch(authorizationServicePod);
  final localStorageService = ref.watch(localStorageServicePod);

  return LogoutNotifier(
    router: router,
    authorizationService: authorizationService,
    localStorageService: localStorageService,
  );
});
