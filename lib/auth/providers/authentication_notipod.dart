import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../router/providers/router_stpod.dart';
import '../../service_providers.dart';
import '../notifiers/authentication_notifier/authentication_notifier.dart';
import '../notifiers/authentication_notifier/union/authentication_union.dart';
import 'auth_model_notipod.dart';
import 'credentials_notipod.dart';

final authenticationNotipod =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationUnion>((ref) {
  final router = ref.watch(routerStpod.notifier);
  final credentialsNotifier = ref.watch(credentialsNotipod.notifier);
  final authModelNotifier = ref.watch(authModelNotipod.notifier);
  final authenticationService = ref.watch(authenticationServicePod);
  final authorizationService = ref.watch(authorizationServicePod);
  final storageService = ref.watch(localStorageServicePod);

  return AuthenticationNotifier(
    router: router,
    credentialsNotifier: credentialsNotifier,
    authModelNotifier: authModelNotifier,
    authenticationService: authenticationService,
    authorizationService: authorizationService,
    storageService: storageService,
  );
});
