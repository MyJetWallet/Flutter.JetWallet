import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../auth/providers/auth_model_notipod.dart';
import '../../../../router/providers/router_stpod.dart';
import '../../../../service_providers.dart';
import '../notifiers/logout_notifier/logout_notifier.dart';
import '../notifiers/logout_notifier/union/logout_union.dart';

final logoutNotipod = StateNotifierProvider<LogoutNotifier, LogoutUnion>(
  (ref) {
    final router = ref.watch(routerStpod.notifier);
    final authService = ref.watch(authServicePod);
    final storageService = ref.watch(localStorageServicePod);
    final authModel = ref.watch(authModelNotipod);
    final signalRService = ref.watch(signalRServicePod);

    return LogoutNotifier(
      router: router,
      authModel: authModel,
      authService: authService,
      storageService: storageService,
      signalRService: signalRService,
    );
  },
);
