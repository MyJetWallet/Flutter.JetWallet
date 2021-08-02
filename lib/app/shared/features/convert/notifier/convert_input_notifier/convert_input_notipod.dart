import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../screens/market/model/currency_model.dart';
import '../../../../../screens/market/provider/currencies_pod.dart';
import '../../helper/remove_element.dart';
import 'convert_input_notifier.dart';
import 'convert_input_state.dart';

final convertInputNotipod = StateNotifierProvider.autoDispose
    .family<ConvertInputNotifier, ConvertInputState, CurrencyModel?>(
  (ref, from) {
    final currencies = ref.read(currenciesPod);

    // If baseBalances of 2 assets are equal, compare by assetBalance
    currencies.sort((a, b) {
      final compare = b.baseBalance.compareTo(a.baseBalance);
      if (compare != 0) return compare;
      return b.assetBalance.compareTo(a.assetBalance);
    });

    final defaultState = _defaultConvertState(
      currencies,
      currencies.first,
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
  final toList = removeElement(from, currencies);
  final to = toList.first;
  final fromList = removeElement(to, currencies);

  return ConvertInputState(
    fromAsset: from,
    fromAssetList: fromList,
    toAsset: to,
    toAssetList: toList,
  );
}
