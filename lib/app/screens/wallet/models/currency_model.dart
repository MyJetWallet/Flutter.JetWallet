import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../service/services/signal_r/model/prices_model.dart';
import '../../../../service/services/wallet/model/asset_converter_map_model.dart';

part 'currency_model.freezed.dart';

@freezed
class CurrencyModel with _$CurrencyModel {
  const factory CurrencyModel({
    required String symbol,
    required String description,
    required double accuracy,
    required int depositMode,
    required int withdrawalMode,
    required int tagType,
    required String assetId,
    required double reserve,
    required String lastUpdate,
    required double sequenceId,
    required double assetBalance,
    required double baseBalance,
  }) = _CurrencyModel;

  const CurrencyModel._();

  bool get isDepositMode => depositMode == 0;

  bool get isWithdrawalMode => withdrawalMode == 0;

  double calculateBaseBalance({
    required PricesModel prices,
    required List<CurrencyModel> currencies,
    required AssetConverterMapModel converter,
  }) {
    var result = assetBalance;

    for (final map in converter.maps) {
      if (map.assetSymbol == symbol) {
        map.operations.sort((a, b) => a.order.compareTo(b.order));

        for (final operation in map.operations) {
          final pair = operation.instrumentPair;
          final isMultiply = operation.isMultiply;

          for (final price in prices.prices) {
            if (pair == price.id) {
              if (operation.useBid) {
                result = _calculate(result, isMultiply, price.bid);
              } else {
                result = _calculate(result, isMultiply, price.ask);
              }
              break;
            }
          }
        }
        break;
      }
    }

    return _round(result, currencies);
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

  double _round(double result, List<CurrencyModel> currencies) {
    var value = result;

    for (final currency in currencies) {
      if (symbol == currency.symbol) {
        final accuracy = currency.accuracy.toInt();
        value = double.parse(result.toStringAsFixed(accuracy));
        break;
      }
    }

    return value;
  }
}
