import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifier/email_verification_notifier.dart';
import '../notifier/email_verification_state.dart';

final emailVerificationNotipod =
    StateNotifierProvider<EmailVerificationNotifier, EmailVerificationState>(
  (ref) {
    const initial = EmailVerificationState(
      email: 'email',
      code: 'code',
    );

    return EmailVerificationNotifier(initial);
  },
  name: 'emailVerificationNotipod',
);
