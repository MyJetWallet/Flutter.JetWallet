import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/currency_model.dart';
import 'send_by_phone_amount_notifier.dart';
import 'send_by_phone_amount_state.dart';

final sendByPhoneAmountNotipod = StateNotifierProvider.autoDispose
    .family<SendByPhoneAmountNotifier, SendByPhoneAmountState, CurrencyModel>(
  (ref, currency) {
    return SendByPhoneAmountNotifier(ref.read, currency);
  },
  name: 'sendByPhoneAmountNotipod',
);
