import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../../../../screens/wallet/model/currency_model.dart';
import '../../../../screens/wallet/provider/currencies_pod.dart';
import '../helper/remove_element.dart';
import '../notifier/convert_notifier.dart';
import '../notifier/convert_state.dart';

final convertNotipod = StateNotifierProvider.autoDispose
    .family<ConvertNotifier, ConvertState, CurrencyModel>(
  (ref, from) {
    // currencies are updating very frequently which
    // results in reseting notifier, to solve this problem
    // we just need to replace ref.watch() to ref.read()
    final currencies = ref.read(currenciesPod);
    final swapService = ref.watch(swapServicePod);

    final defaultState = _defaultConvertState(currencies, from);

    return ConvertNotifier(
      defaultState: defaultState,
      currencies: currencies,
      swapService: swapService,
    );
  },
);

ConvertState _defaultConvertState(
  List<CurrencyModel> currencies,
  CurrencyModel from,
) {
  final toList = removeElement(from, currencies);
  final to = toList.first;
  final fromList = removeElement(to, currencies);

  return ConvertState(
    from: from,
    fromList: fromList,
    to: to,
    toList: toList,
    amountTextController: TextEditingController(),
  );
}
