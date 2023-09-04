import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'execute_quote_response_model.freezed.dart';
part 'execute_quote_response_model.g.dart';

@freezed
class ExecuteQuoteResponseModel with _$ExecuteQuoteResponseModel {
  const factory ExecuteQuoteResponseModel({
    required bool isFromFixed,
    required bool isExecuted,
    required String operationId,
    @DecimalSerialiser() required Decimal price,
    @JsonKey(name: 'fromAsset') required String fromAssetSymbol,
    @JsonKey(name: 'toAsset') required String toAssetSymbol,
    @DecimalSerialiser()
    @JsonKey(name: 'fromAssetVolume')
    required Decimal fromAssetAmount,
    @DecimalSerialiser()
    @JsonKey(name: 'toAssetVolume')
    required Decimal toAssetAmount,
    @JsonKey(name: 'actualTimeInSecond') required int expirationTime,
  }) = _ExecuteQuoteResponseModel;

  factory ExecuteQuoteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExecuteQuoteResponseModelFromJson(json);
}
