import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/currency_model.dart';
import 'withdrawal_amount_notifier.dart';
import 'withdrawal_amount_state.dart';

final withdrawalAmountNotipod = StateNotifierProvider.autoDispose
    .family<WithdrawalAmountNotifier, WithdrawalAmountState, CurrencyModel>(
  (ref, currency) {
    return WithdrawalAmountNotifier(ref.read, currency);
  },
);
