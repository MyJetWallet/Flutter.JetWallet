import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service_providers.dart';
import '../../../../screens/wallet/models/asset_with_balance_model.dart';
import '../../../../screens/wallet/providers/assets_with_balances_pod.dart';
import '../helpers/remove_element.dart';
import '../notifier/convert_notifier.dart';
import '../notifier/convert_state.dart';

final convertNotipod = StateNotifierProvider.autoDispose
    .family<ConvertNotifier, ConvertState, AssetWithBalanceModel>(
  (ref, from) {
    // currencies are updating very frequently which
    // results in reseting notifier, to solve this problem
    // we just need to replace ref.watch() to ref.read()
    final currencies = ref.read(assetsWithBalancesPod);
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
  List<AssetWithBalanceModel> currencies,
  AssetWithBalanceModel from,
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
