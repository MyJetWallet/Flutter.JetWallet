import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/providers/other/navigator_key_pod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../sign_in_up/notifier/auth_model_notifier/auth_model_notipod.dart';
import 'email_verification_notifier.dart';
import 'email_verification_state.dart';

final emailVerificationNotipod = StateNotifierProvider.autoDispose<
    EmailVerificationNotifier, EmailVerificationState>(
  (ref) {
    final authModel = ref.watch(authModelNotipod);
    final validationService = ref.watch(validationServicePod);
    final navigatorKey = ref.watch(navigatorKeyPod);

    return EmailVerificationNotifier(
      email: authModel.email,
      service: validationService,
      context: navigatorKey.currentContext!,
    );
  },
  name: 'emailVerificationNotipod',
);
