import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/phone_verification_trigger_union.dart';
import 'phone_verification_enter_notifier.dart';
import 'phone_verification_enter_state.dart';

final phoneVerificationEnterNotipod = StateNotifierProvider.autoDispose.family<
    PhoneVerificationEnterNotifier,
    PhoneVerificationEnterState,
    PhoneVerificationTriggerUnion>(
  (ref, trigger) {
    return PhoneVerificationEnterNotifier(trigger);
  },
  name: 'phoneVerificationEnterNotipod',
);
