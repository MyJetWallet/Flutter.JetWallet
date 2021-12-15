import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'send_by_phone_input_notifier.dart';
import 'send_by_phone_input_state.dart';

final sendByPhoneInputNotipod =
    StateNotifierProvider<SendByPhoneInputNotifier, SendByPhoneInputState>(
  (ref) {
    return SendByPhoneInputNotifier(ref.read);
  },
  name: 'sendByPhoneInputNotipod',
);
