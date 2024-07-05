import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'invest_prices_model.freezed.dart';
part 'invest_prices_model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class InvestPricesModel with _$InvestPricesModel {
  const factory InvestPricesModel({
    required List<InvestPriceModel> prices,
  }) = _InvestPricesModel;

  factory InvestPricesModel.fromJson(Map<String, dynamic> json) => _$InvestPricesModelFromJson(json);
}

@freezed
class InvestPriceModel with _$InvestPriceModel {
  const factory InvestPriceModel({
    String? symbol,
    DateTime? timestamp,
    @DecimalNullSerialiser() Decimal? lastPrice,
    @DecimalNullSerialiser() Decimal? askPrice,
    @DecimalNullSerialiser() Decimal? bidPrice,
  }) = _InvestPriceModel;

  factory InvestPriceModel.fromJson(Map<String, dynamic> json) => _$InvestPriceModelFromJson(json);
}
