import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/currency_model.dart';
import 'send_by_phone_confirm_notifier.dart';
import 'send_by_phone_confirm_state.dart';

final sendByPhoneConfirmNotipod = StateNotifierProvider.autoDispose
    .family<SendByPhoneConfirmNotifier, SendByPhoneConfirmState, CurrencyModel>(
  (ref, currency) {
    return SendByPhoneConfirmNotifier(ref.read, currency);
  },
  name: 'sendByPhoneConfirmNotipod',
);
