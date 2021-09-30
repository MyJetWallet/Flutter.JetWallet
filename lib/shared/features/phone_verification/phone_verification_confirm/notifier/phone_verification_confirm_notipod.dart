import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'phone_verification_confirm_notifier.dart';
import 'phone_verification_confirm_state.dart';

final phoneVerificationConfirmNotipod = StateNotifierProvider.autoDispose<
    PhoneVerificationConfirmNotifier, PhoneVerificationConfirmState>(
  (ref) {
    return PhoneVerificationConfirmNotifier(ref.read);
  },
  name: 'phoneVerificationConfirmNotipod',
);
