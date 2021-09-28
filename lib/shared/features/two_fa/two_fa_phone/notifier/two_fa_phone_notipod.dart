import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/two_fa_phone_trigger_union.dart';
import 'two_fa_phone_notifier.dart';
import 'two_fa_phone_state.dart';

final twoFaPhoneNotipod = StateNotifierProvider.autoDispose
    .family<TwoFaPhoneNotifier, TwoFaPhoneState, TwoFaPhoneTriggerUnion>(
  (ref, trigger) {
    return TwoFaPhoneNotifier(ref.read, trigger);
  },
  name: 'twoFaPhoneNotipod',
);
