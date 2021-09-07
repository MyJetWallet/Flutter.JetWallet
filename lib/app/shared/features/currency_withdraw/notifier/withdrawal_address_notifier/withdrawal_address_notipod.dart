import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/currency_model.dart';
import 'withdrawal_address_notifier.dart';
import 'withdrawal_address_state.dart';

final withdrawalAddressNotipod = StateNotifierProvider.autoDispose
    .family<WithdrawalAddressNotifier, WithdrawalAddressState, CurrencyModel>(
  (ref, currency) {
    return WithdrawalAddressNotifier(ref.read, currency);
  },
);
