import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'phone_verification_enter_notifier.dart';
import 'send_input_phone_number_state.dart';

final sendInputPhoneNumberNotipod = StateNotifierProvider.autoDispose<
    SendInputPhoneNumberNotifier, SendInputPhoneNumberState>(
  (ref) {
    return SendInputPhoneNumberNotifier();
  },
  name: 'sendInputPhoneNumberNotipod',
);
