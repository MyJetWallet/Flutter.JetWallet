import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'get_quote_request_model.freezed.dart';
part 'get_quote_request_model.g.dart';

@freezed
class GetQuoteRequestModel with _$GetQuoteRequestModel {
  const factory GetQuoteRequestModel({
    @Default(true) bool isFromFixed,
    @DecimalSerialiser()
    @JsonKey(name: 'fromAssetVolume')
    Decimal? fromAssetAmount,
    RecurringBuyModel? recurringBuy,
    @DecimalSerialiser() @JsonKey(name: 'toAssetVolume') Decimal? toAssetAmount,
    @JsonKey(name: 'fromAsset') required String fromAssetSymbol,
    @JsonKey(name: 'toAsset') required String toAssetSymbol,
  }) = _GetQuoteRequestModel;

  factory GetQuoteRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GetQuoteRequestModelFromJson(json);
}

@freezed
class RecurringBuyModel with _$RecurringBuyModel {
  const factory RecurringBuyModel({
    required RecurringBuysType scheduleType,
  }) = _RecurringBuyModel;

  factory RecurringBuyModel.fromJson(Map<String, dynamic> json) =>
      _$RecurringBuyModelFromJson(json);
}

enum RecurringBuysType {
  @JsonValue(0)
  oneTimePurchase,
  @JsonValue(1)
  daily,
  @JsonValue(2)
  weekly,
  @JsonValue(3)
  biWeekly,
  @JsonValue(4)
  monthly,
}
