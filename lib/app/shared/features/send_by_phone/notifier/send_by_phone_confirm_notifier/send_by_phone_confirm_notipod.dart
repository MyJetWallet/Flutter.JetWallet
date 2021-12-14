import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'send_by_phone_confirm_notifier.dart';
import 'send_by_phone_confirm_state.dart';

final sendByPhoneConfirmNotipod =
    StateNotifierProvider<SendByPhoneConfirmNotifier, SendByPhoneConfirmState>(
  (ref) {
    return SendByPhoneConfirmNotifier();
  },
  name: 'sendByPhoneConfirmNotipod',
);
