import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'reset_password_notifier.dart';
import 'reset_password_state.dart';

final resetPasswordNotipod =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
  (ref) {
    return ResetPasswordNotifier(ref.read);
  },
);
