import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/currency_model.dart';
import 'currency_sell_notifier.dart';
import 'currency_sell_state.dart';

final currencySellNotipod = StateNotifierProvider.autoDispose
    .family<CurrencySellNotifier, CurrencySellState, CurrencyModel>(
  (ref, currency) {
    return CurrencySellNotifier(ref.read, currency);
  },
);
