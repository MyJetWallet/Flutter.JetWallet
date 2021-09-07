import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/currency_model.dart';

import 'withdrawal_confirm_notifier.dart';

final withdrawalConfirmNotipod = StateNotifierProvider.autoDispose
    .family<WithdrawalConfirmNotifier, void, CurrencyModel>(
  (ref, currency) {
    return WithdrawalConfirmNotifier(ref.read, currency);
  },
);
