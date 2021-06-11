import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../router/provider/router_stpod/router_stpod.dart';
import '../../service_providers.dart';
import '../notifier/authentication_notifier/authentication_notifier.dart';
import '../notifier/authentication_notifier/authentication_union.dart';
import 'auth_model_notipod.dart';
import 'credentials_notipod.dart';

final authenticationNotipod =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationUnion>(
  (ref) {
    final router = ref.watch(routerStpod.notifier);
    final credentialsState = ref.watch(credentialsNotipod);
    final credentialsNotifier = ref.watch(credentialsNotipod.notifier);
    final authModelNotifier = ref.watch(authModelNotipod.notifier);
    final authService = ref.watch(authServicePod);
    final storageService = ref.watch(localStorageServicePod);

    return AuthenticationNotifier(
      router: router,
      credentialsState: credentialsState,
      credentialsNotifier: credentialsNotifier,
      authModelNotifier: authModelNotifier,
      authService: authService,
      storageService: storageService,
    );
  },
);
