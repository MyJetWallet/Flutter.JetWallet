import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/currency_model.dart';
import 'high_yield_buy_notifier.dart';
import 'high_yield_buy_state.dart';

final highYieldBuyNotipod = StateNotifierProvider.autoDispose
    .family<HighYieldBuyNotifier, HighYieldBuyState, CurrencyModel>(
  (ref, currency) {
    return HighYieldBuyNotifier(ref.read, currency);
  },
);
