import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/providers/service_providers.dart';
import 'forgot_password_notifier.dart';
import 'forgot_password_state.dart';

final forgotPasswordNotipod =
    StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>(
  (ref) {
    final authService = ref.watch(authServicePod);

    return ForgotPasswordNotifier(
      authService: authService,
    );
  },
);
