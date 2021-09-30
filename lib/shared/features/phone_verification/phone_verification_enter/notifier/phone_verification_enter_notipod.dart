import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'phone_verification_enter_notifier.dart';
import 'phone_verification_enter_state.dart';

final phoneVerificationEnterNotipod = StateNotifierProvider.autoDispose<
    PhoneVerificationEnterNotifier, PhoneVerificationEnterState>(
  (ref) {
    return PhoneVerificationEnterNotifier();
  },
  name: 'phoneVerificationEnterNotipod',
);
