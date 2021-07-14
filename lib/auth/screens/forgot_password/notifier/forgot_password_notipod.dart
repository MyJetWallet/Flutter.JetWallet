import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/providers/service_providers.dart';
import '../../sign_in_up/notifier/credentials_notifier/credentials_notipod.dart';
import 'forgot_password_notifier.dart';
import 'forgot_password_union.dart';

final forgotPasswordNotipod =
    StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordUnion>(
  (ref) {
    final credentialsState = ref.watch(credentialsNotipod);
    final credentialsNotifier = ref.watch(credentialsNotipod.notifier);
    final authService = ref.watch(authServicePod);

    return ForgotPasswordNotifier(
      credentialsState: credentialsState,
      credentialsNotifier: credentialsNotifier,
      authService: authService,
    );
  },
);
