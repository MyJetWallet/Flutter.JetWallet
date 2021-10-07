import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'phone_verification_confirm_notifier.dart';
import 'phone_verification_confirm_state.dart';

final phoneVerificationConfirmNotipod = StateNotifierProvider.autoDispose
    .family<PhoneVerificationConfirmNotifier, PhoneVerificationConfirmState,
        Function()>(
  (ref, onVerified) {
    return PhoneVerificationConfirmNotifier(ref.read, onVerified);
  },
  name: 'phoneVerificationConfirmNotipod',
);
