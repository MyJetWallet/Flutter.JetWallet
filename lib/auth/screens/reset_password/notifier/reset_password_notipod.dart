import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view/reset_password.dart';
import 'reset_password_notifier.dart';
import 'reset_password_state.dart';

final resetPasswordNotipod = StateNotifierProvider.autoDispose
    .family<ResetPasswordNotifier, ResetPasswordState, ResetPasswordArgs>(
  (ref, args) {
    return ResetPasswordNotifier(ref.read, args);
  },
);
