import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/providers/other/navigator_key_pod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../sign_in_up/notifier/credentials_notifier/credentials_notipod.dart';
import 'reset_password_notifier.dart';
import 'reset_password_union.dart';

final resetPasswordNotipod =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordUnion>(
  (ref) {
    final credentialsState = ref.watch(credentialsNotipod);
    final credentialsNotifier = ref.watch(credentialsNotipod.notifier);
    final authService = ref.watch(authServicePod);
    final navigatorKey = ref.watch(navigatorKeyPod);

    return ResetPasswordNotifier(
      credentialsState: credentialsState,
      credentialsNotifier: credentialsNotifier,
      authService: authService,
      navigatorKey: navigatorKey,
    );
  },
);
