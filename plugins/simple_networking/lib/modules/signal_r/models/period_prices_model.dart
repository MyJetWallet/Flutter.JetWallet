import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'period_prices_model.freezed.dart';
part 'period_prices_model.g.dart';

@freezed
class PeriodPricesModel with _$PeriodPricesModel {
  const factory PeriodPricesModel({
    @JsonKey(name: 'priceRecords') required List<PeriodPriceModel> prices,
  }) = _PeriodPricesModel;

  factory PeriodPricesModel.fromJson(Map<String, dynamic> json) => _$PeriodPricesModelFromJson(json);
}

@freezed
class PeriodPriceModel with _$PeriodPriceModel {
  const factory PeriodPriceModel({
    required String assetSymbol,
    @JsonKey(name: 'h24') required PeriodModel dayPrice,
    @JsonKey(name: 'd7') required PeriodModel weekPrice,
    @JsonKey(name: 'm1') required PeriodModel monthPrice,
    @JsonKey(name: 'm3') required PeriodModel threeMonthPrice,
  }) = _PeriodPriceModel;

  factory PeriodPriceModel.fromJson(Map<String, dynamic> json) => _$PeriodPriceModelFromJson(json);
}

@freezed
class PeriodModel with _$PeriodModel {
  const factory PeriodModel({
    @DecimalSerialiser() required Decimal price,
    @JsonKey(name: 'recordTime') required String date,
  }) = _PeriodModel;

  factory PeriodModel.fromJson(Map<String, dynamic> json) => _$PeriodModelFromJson(json);
}
