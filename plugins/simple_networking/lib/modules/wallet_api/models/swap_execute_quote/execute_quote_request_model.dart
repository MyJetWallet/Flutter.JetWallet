import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

import '../get_quote/get_quote_response_model.dart';

part 'execute_quote_request_model.freezed.dart';
part 'execute_quote_request_model.g.dart';

@freezed
class ExecuteQuoteRequestModel with _$ExecuteQuoteRequestModel {
  const factory ExecuteQuoteRequestModel({
    @Default(true) bool isFromFixed,
    required String operationId,
    @DecimalSerialiser() required Decimal price,
    @JsonKey(name: 'fromAsset') required String fromAssetSymbol,
    @JsonKey(name: 'toAsset') required String toAssetSymbol,
    @DecimalSerialiser()
    @JsonKey(name: 'fromAssetVolume')
    Decimal? fromAssetAmount,
    @DecimalSerialiser()
    @JsonKey(name: 'toAssetVolume')
    required Decimal? toAssetAmount,
    RecurringBuyInfoModel? recurringBuyInfo,
  }) = _ExecuteQuoteRequestModel;

  factory ExecuteQuoteRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ExecuteQuoteRequestModelFromJson(json);
}
