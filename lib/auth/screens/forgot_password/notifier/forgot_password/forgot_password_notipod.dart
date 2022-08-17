import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../view/forgot_password.dart';
import 'forgot_password_notifier.dart';
import 'forgot_password_state.dart';

final forgotPasswordNotipod = StateNotifierProvider.autoDispose
    .family<ForgotPasswordNotifier, ForgotPasswordState, ForgotPasswordArgs>(
  (ref, args) {
    return ForgotPasswordNotifier(ref.read, args);
  },
);
