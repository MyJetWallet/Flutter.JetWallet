import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/currency_model.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../provider/action_buy_filtered_stpod.dart';
import 'currencies_notifier.dart';

final currenciesNotipod =
    StateNotifierProvider.autoDispose<CurrenciesNotifier, List<CurrencyModel>>(
        (ref) {
  final currencies = ref.watch(currenciesPod);
  final search = ref.watch(actionBuyFilteredStpod);

  return CurrenciesNotifier(
    read: ref.read,
    currencies: currencies,
    search: search.state,
  );
});
