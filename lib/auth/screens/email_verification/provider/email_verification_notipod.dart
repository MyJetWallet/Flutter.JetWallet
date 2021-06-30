import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service_providers.dart';
import '../../../../shared/providers/other/navigator_key_pod.dart';
import '../../sign_in_up/provider/auth_model_notipod.dart';
import '../notifier/email_verification_notifier.dart';
import '../notifier/email_verification_state.dart';

final emailVerificationNotipod =
    StateNotifierProvider<EmailVerificationNotifier, EmailVerificationState>(
  (ref) {
    final authModel = ref.watch(authModelNotipod);
    final authService = ref.watch(authServicePod);
    final navigatorKey = ref.watch(navigatorKeyPod);

    return EmailVerificationNotifier(
      email: authModel.email,
      authService: authService,
      context: navigatorKey.currentContext!,
    );
  },
  name: 'emailVerificationNotipod',
);
