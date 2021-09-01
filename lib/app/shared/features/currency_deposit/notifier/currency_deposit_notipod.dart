import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'currency_deposit_notifier.dart';
import 'currency_deposit_state.dart';

final currencyDepositNotipod = StateNotifierProvider.autoDispose
    .family<CurrencyDepositNotifier, CurrencyDepositState, String>(
  (ref, assetSymbol) {
    return CurrencyDepositNotifier(
      read: ref.read,
      assetSymbol: assetSymbol,
    );
  },
);
