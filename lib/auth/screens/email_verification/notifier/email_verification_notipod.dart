import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'email_verification_notifier.dart';
import 'email_verification_state.dart';

final emailVerificationNotipod = StateNotifierProvider.autoDispose<
    EmailVerificationNotifier, EmailVerificationState>(
  (ref) {
    return EmailVerificationNotifier(ref.read);
  },
  name: 'emailVerificationNotipod',
);
