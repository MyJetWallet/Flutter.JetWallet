import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/decimal_serialiser.dart';

part 'execute_quote_request_model.freezed.dart';
part 'execute_quote_request_model.g.dart';

@freezed
class ExecuteQuoteRequestModel with _$ExecuteQuoteRequestModel {
  const factory ExecuteQuoteRequestModel({
    required bool isFromFixed,
    required String operationId,
    @DecimalSerialiser() required Decimal price,
    @JsonKey(name: 'fromAsset') required String fromAssetSymbol,
    @JsonKey(name: 'toAsset') required String toAssetSymbol,
    @DecimalSerialiser()
    @JsonKey(name: 'fromAssetVolume')
        Decimal? fromAssetAmount,
    @DecimalSerialiser()
    @JsonKey(name: 'toAssetVolume')
        required Decimal toAssetAmount,
  }) = _ExecuteQuoteRequestModel;

  factory ExecuteQuoteRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ExecuteQuoteRequestModelFromJson(json);
}
