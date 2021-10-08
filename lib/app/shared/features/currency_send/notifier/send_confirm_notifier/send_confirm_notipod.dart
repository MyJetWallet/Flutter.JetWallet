import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../currency_withdraw/model/withdrawal_model.dart';

import 'send_confirm_notifier.dart';

final sendConfirmNotipod = StateNotifierProvider.autoDispose
    .family<SendConfirmNotifier, void, WithdrawalModel>(
  (ref, withdrawal) {
    return SendConfirmNotifier(ref.read, withdrawal);
  },
);
