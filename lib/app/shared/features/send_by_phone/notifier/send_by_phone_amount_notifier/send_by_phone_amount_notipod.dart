import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'send_by_phone_amount_notifier.dart';
import 'send_by_phone_amount_state.dart';

final sendByPhoneAmountNotipod =
    StateNotifierProvider<SendByPhoneAmountNotifier, SendByPhoneAmountState>(
  (ref) {
    return SendByPhoneAmountNotifier();
  },
  name: 'sendByPhoneAmountNotipod',
);
