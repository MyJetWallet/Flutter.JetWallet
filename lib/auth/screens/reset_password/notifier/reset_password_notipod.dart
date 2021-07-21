import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/providers/service_providers.dart';
import 'reset_password_notifier.dart';
import 'reset_password_state.dart';

final resetPasswordNotipod =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
  (ref) {
    final authService = ref.watch(authServicePod);

    return ResetPasswordNotifier(
      authService: authService,
    );
  },
);
