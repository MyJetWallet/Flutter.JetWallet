import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service_providers.dart';
import '../../sign_in_up/provider/credentials_notipod.dart';
import '../notifier/forgot_password_notifier.dart';
import '../notifier/forgot_password_union.dart';

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
