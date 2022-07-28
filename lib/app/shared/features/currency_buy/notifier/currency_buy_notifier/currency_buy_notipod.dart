import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/currency_model.dart';
import '../../../key_value/notifier/key_value_notipod.dart';
import 'currency_buy_notifier.dart';
import 'currency_buy_state.dart';

final currencyBuyNotipod = StateNotifierProvider.autoDispose
    .family<CurrencyBuyNotifier, CurrencyBuyState, CurrencyModel>(
  (ref, currency) {
    final keyValue = ref.watch(keyValueNotipod);

    return CurrencyBuyNotifier(
      ref.read,
      currency,
      keyValue.lastUsedPaymentMethod,
    );
  },
);
