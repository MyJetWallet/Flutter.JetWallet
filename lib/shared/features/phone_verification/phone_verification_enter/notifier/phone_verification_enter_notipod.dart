import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'phone_verification_enter_notifier.dart';
import 'phone_verification_enter_state.dart';

final phoneVerificationEnterNotipod = StateNotifierProvider.autoDispose.family<
    PhoneVerificationEnterNotifier, PhoneVerificationEnterState, Function()>(
  (ref, onVerified) {
    return PhoneVerificationEnterNotifier(onVerified);
  },
  name: 'phoneVerificationEnterNotipod',
);
