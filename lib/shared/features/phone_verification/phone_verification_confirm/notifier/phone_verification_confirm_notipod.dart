import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/phone_verification_trigger_union.dart';
import 'phone_verification_confirm_notifier.dart';
import 'phone_verification_confirm_state.dart';

final phoneVerificationConfirmNotipod = StateNotifierProvider.autoDispose
    .family<PhoneVerificationConfirmNotifier, PhoneVerificationConfirmState,
        PhoneVerificationTriggerUnion>(
  (ref, trigger) {
    return PhoneVerificationConfirmNotifier(ref.read, trigger);
  },
  name: 'phoneVerificationConfirmNotipod',
);
