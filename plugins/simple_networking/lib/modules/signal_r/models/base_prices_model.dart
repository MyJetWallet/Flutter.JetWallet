import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'base_prices_model.freezed.dart';
part 'base_prices_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class BasePricesModel with _$BasePricesModel {
  const factory BasePricesModel({
    @JsonKey(name: 'P') required List<BasePriceModel> prices,
  }) = _BasePricesModel;

  factory BasePricesModel.fromJson(Map<String, dynamic> json) => _$BasePricesModelFromJson(json);

  /// Takes previous snapshot of basePrices and
  /// applies the new update to them
  factory BasePricesModel.fromNewPrices({
    required Map<String, dynamic> json,
    required BasePricesModel oldPrices,
  }) {
    final newPrices = BasePricesModel.fromJson(json);

    if (oldPrices.prices.isNotEmpty) {
      for (final newPrice in newPrices.prices) {
        for (final oldPrice in oldPrices.prices) {
          if (oldPrice.assetSymbol == newPrice.assetSymbol) {
            final index = oldPrices.prices.indexOf(oldPrice);

            oldPrices.prices[index] = oldPrice.copyWith(
              time: newPrice.time,
              currentPrice: newPrice.currentPrice,
              dayPriceChange: newPrice.dayPriceChange,
              dayPercentChange: newPrice.dayPercentChange,
            );
          }
        }
      }
    } else {
      return newPrices;
    }

    return oldPrices;
  }
}

@freezed
class BasePriceModel with _$BasePriceModel {
  const factory BasePriceModel({
    @JsonKey(name: 'T') @Default(0.0) double time,
    @JsonKey(name: 'P24p') @Default(0.0) double dayPercentChange,
    @DecimalSerialiser() @JsonKey(name: 'P') required Decimal currentPrice,
    @DecimalSerialiser() @JsonKey(name: 'P24a') required Decimal dayPriceChange,
    @JsonKey(name: 'S') required String assetSymbol,
  }) = _PeriodPriceModel;

  factory BasePriceModel.fromJson(Map<String, dynamic> json) => _$BasePriceModelFromJson(json);
}
