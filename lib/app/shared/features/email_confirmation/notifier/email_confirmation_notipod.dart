import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'email_confirmation_notifier.dart';
import 'email_confirmation_state.dart';

final emailConfirmationNotipod = StateNotifierProvider.autoDispose<
    EmailConfirmationNotifier, EmailConfirmationState>(
  (ref) {
    return EmailConfirmationNotifier(ref.read);
  },
  name: 'emailConfirmationNotipod',
);
