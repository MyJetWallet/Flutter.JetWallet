import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../auth/providers/authentication_model_stpod.dart';
import '../../../../router/providers/router_stpod.dart';
import '../../../../service_providers.dart';
import '../notifiers/logout_notifier/logout_notifier.dart';
import '../notifiers/logout_notifier/union/logout_union.dart';


final logoutNotipod =
    StateNotifierProvider<LogoutNotifier, LogoutUnion>((ref) {
  final router = ref.read(routerStpod);
  final authModel = ref.read(authenticationModelStpod);
  final authorizationService = ref.read(authorizationServicePod);
  final localStorageService = ref.read(localStorageServicePod);

  return LogoutNotifier(
    router: router,
    authModel: authModel,
    authorizationService: authorizationService,
    localStorageService: localStorageService,
  );
});
