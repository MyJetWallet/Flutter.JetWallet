import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../screens/market/helper/calculate_base_balance.dart';
import '../../screens/market/provider/converter_map_fpod.dart';
import '../../screens/market/provider/instruments_spod.dart';
import '../../screens/market/provider/prices_spod.dart';
import '../providers/base_currency_pod/base_currency_pod.dart';

/// Responsible for converting asset balance to the base balance \
/// TODO After merge: 1) rename to calculateBaseBalance \
/// TODO 2) and make original calculateBaseBalance private here
double calculateBaseBalanceWithPods({
  required Reader read,
  required String assetSymbol,
  required double assetBalance,
}) {
  var baseValue = 0.0;

  read(instrumentsSpod).whenData((instrumentsData) {
    read(pricesSpod).whenData((pricesData) {
      read(converterMapFpod).whenData((converterData) {
        final baseCurrency = read(baseCurrencyPod);

        baseValue = calculateBaseBalance(
          accuracy: baseCurrency.accuracy.toInt(),
          assetSymbol: assetSymbol,
          assetBalance: assetBalance,
          prices: pricesData.prices,
          converter: converterData,
        );
      });
    });
  });

  return baseValue;
}
