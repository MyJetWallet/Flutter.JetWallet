import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/withdrawal_model.dart';
import 'withdrawal_amount_notifier.dart';
import 'withdrawal_amount_state.dart';

final withdrawalAmountNotipod = StateNotifierProvider.autoDispose
    .family<WithdrawalAmountNotifier, WithdrawalAmountState, WithdrawalModel>(
  (ref, withdrawal) {
    return WithdrawalAmountNotifier(ref.read, withdrawal);
  },
);
