import '../../../../service/services/signal_r/model/prices_model.dart';
import '../../../../service/services/wallet/model/asset_converter_map/asset_converter_map_model.dart';

/// returns [-1] if there is no prices available for specific asset
double calculateBaseBalance({
  required int accuracy,
  required String baseSymbol,
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

  if (baseSymbol == assetSymbol) {
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
