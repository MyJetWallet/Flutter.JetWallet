import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'confirm_password_reset_notifier.dart';
import 'confirm_password_reset_state.dart';

final confirmPasswordResetNotipod = StateNotifierProvider.autoDispose
    .family<ConfirmPasswordResetNotifier, ConfirmPasswordResetState, String>(
  (ref, email) {
    return ConfirmPasswordResetNotifier(ref.read, email);
  },
  name: 'confirmPasswordResetNotipod',
);
