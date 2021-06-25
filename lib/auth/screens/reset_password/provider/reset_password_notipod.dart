import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service_providers.dart';
import '../../sign_in_up/provider/credentials_notipod.dart';
import '../notifier/reset_password_notifier.dart';
import '../notifier/reset_password_union.dart';

final resetPasswordNotipod =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordUnion>(
  (ref) {
    final credentialsState = ref.watch(credentialsNotipod);
    final authService = ref.watch(authServicePod);

    return ResetPasswordNotifier(
      credentialsState: credentialsState,
      authService: authService,
    );
  },
);
