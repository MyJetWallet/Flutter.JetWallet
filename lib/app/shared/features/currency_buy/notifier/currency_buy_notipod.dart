import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'currency_buy_notifier.dart';
import 'currency_buy_state.dart';

final currencyBuyNotipod =
    StateNotifierProvider.autoDispose<CurrencyBuyNotifier, CurrencyBuyState>(
  (ref) {
    return CurrencyBuyNotifier(ref.read);
  },
);
