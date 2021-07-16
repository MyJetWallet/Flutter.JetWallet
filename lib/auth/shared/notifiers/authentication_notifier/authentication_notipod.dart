import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../router/provider/router_stpod/router_stpod.dart';
import '../../../../../shared/providers/other/navigator_key_pod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../auth_info_notifier/auth_info_notipod.dart';
import 'authentication_notifier.dart';
import 'authentication_union.dart';

final authenticationNotipod =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationUnion>(
  (ref) {
    final router = ref.watch(routerStpod.notifier);
    final authInfoN = ref.watch(authInfoNotipod.notifier);
    final authService = ref.watch(authServicePod);
    final storageService = ref.watch(localStorageServicePod);
    final navigatorKey = ref.watch(navigatorKeyPod);
    final rsaService = ref.watch(rsaServicePod);

    return AuthenticationNotifier(
      router: router,
      authInfoN: authInfoN,
      authService: authService,
      storageService: storageService,
      navigatorKey: navigatorKey,
      rsaService: rsaService,
    );
  },
);
