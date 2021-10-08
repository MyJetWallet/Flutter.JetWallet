import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';

import 'send_amount_notifier.dart';
import 'send_amount_state.dart';

final sendAmountNotipod = StateNotifierProvider.autoDispose
    .family<SendAmountNotifier, SendAmountState, WithdrawalModel>(
  (ref, withdrawal) {
    return SendAmountNotifier(ref.read, withdrawal);
  },
);
