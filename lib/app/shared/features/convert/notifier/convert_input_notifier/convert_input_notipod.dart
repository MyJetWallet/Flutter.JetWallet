import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../helpers/currencies_helpers.dart';
import '../../../../models/currency_model.dart';
import '../../../../providers/currencies_pod/currencies_pod.dart';
import '../../helper/remove_currency_from_list.dart';
import 'convert_input_notifier.dart';
import 'convert_input_state.dart';

final convertInputNotipod = StateNotifierProvider.autoDispose
    .family<ConvertInputNotifier, ConvertInputState, CurrencyModel?>(
  (ref, from) {
    final currencies = List<CurrencyModel>.from(
      ref.read(currenciesPod),
    );

    sortCurrencies(currencies);

    final defaultState = _defaultConvertState(
      currencies,
      from ?? currencies.first,
    );

    return ConvertInputNotifier(
      defaultState: defaultState,
      currencies: currencies,
    );
  },
);

ConvertInputState _defaultConvertState(
  List<CurrencyModel> currencies,
  CurrencyModel from,
) {
  final toList = removeCurrencyFromList(from, currencies);
  final to = toList.first;
  final fromList = removeCurrencyFromList(to, currencies);

  return ConvertInputState(
    fromAsset: from,
    fromAssetList: fromList,
    toAsset: to,
    toAssetList: toList,
  );
}
