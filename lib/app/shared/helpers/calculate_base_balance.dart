import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../service/services/signal_r/model/prices_model.dart';
import '../../../service/services/wallet/model/asset_converter_map/asset_converter_map_model.dart';
import '../providers/base_currency_pod/base_currency_pod.dart';
import '../providers/converter_map_fpod/converter_map_fpod.dart';
import '../providers/signal_r/prices_spod.dart';

/// Responsible for converting asset balance to the base balance.
/// Doesn't work properly inside currenciesPod and marketItemsPod.
/// In order to make it work, I need to listen for prices (ref.watch) which
/// destroys  the purpose of the function because I still need to reference
/// dependencies of the function and the function was created 
/// to reduce them, abstract from them
double calculateBaseBalanceWithReader({
  required Reader read,
  required String assetSymbol,
  required double assetBalance,
}) {
  var baseValue = 0.0;

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

  return baseValue;
}

/// returns [-1] if there is no prices available for specific asset
double calculateBaseBalance({
  required int accuracy,
  required String assetSymbol,
  required double assetBalance,
  required List<PriceModel> prices,
  required AssetConverterMapModel converter,
}) {
  var result = assetBalance;
  var isAvailable = false;

  if (assetBalance == 0) {
    return 0;
  }

  if (converter.baseAssetSymbol == assetSymbol) {
    return assetBalance;
  }

  for (final map in converter.maps) {
    if (map.assetSymbol == assetSymbol) {
      map.operations.sort((a, b) => a.order.compareTo(b.order));

      for (final operation in map.operations) {
        final pair = operation.instrumentPair;
        final isMultiply = operation.isMultiply;

        for (final price in prices) {
          if (pair == price.id) {
            if (operation.useBid) {
              result = _calculate(result, isMultiply, price.bid);
            } else {
              result = _calculate(result, isMultiply, price.ask);
            }
            isAvailable = true;
            break;
          }
        }
      }
      break;
    }
  }

  if (isAvailable) {
    return double.parse(result.toStringAsFixed(accuracy));
  } else {
    return -1;
  }
}

double _calculate(double result, bool isMultiply, double price) {
  double value;

  if (isMultiply) {
    value = result * price;
  } else {
    value = result / price;
  }

  return value;
}
