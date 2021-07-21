import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../router/provider/authorized_stpod/authorized_stpod.dart';
import '../../../../shared/providers/other/navigator_key_pod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import 'email_verification_notifier.dart';
import 'email_verification_state.dart';

final emailVerificationNotipod = StateNotifierProvider.autoDispose<
    EmailVerificationNotifier, EmailVerificationState>(
  (ref) {
    final authInfo = ref.watch(authInfoNotipod);
    final validationService = ref.watch(validationServicePod);
    final authorized = ref.watch(authorizedStpod.notifier);
    final navigatorKey = ref.watch(navigatorKeyPod);

    return EmailVerificationNotifier(
      email: authInfo.email,
      service: validationService,
      authorized: authorized,
      context: navigatorKey.currentContext!,
    );
  },
  name: 'emailVerificationNotipod',
);
