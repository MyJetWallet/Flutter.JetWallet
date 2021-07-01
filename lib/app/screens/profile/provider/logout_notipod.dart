import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../auth/screens/sign_in_up/provider/auth_model_notipod.dart';
import '../../../../router/provider/router_stpod/router_stpod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../notifier/logout_notifier.dart';
import '../notifier/logout_union.dart';

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
