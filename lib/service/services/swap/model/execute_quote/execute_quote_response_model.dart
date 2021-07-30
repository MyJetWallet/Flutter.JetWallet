import 'package:freezed_annotation/freezed_annotation.dart';

part 'execute_quote_response_model.freezed.dart';
part 'execute_quote_response_model.g.dart';

@freezed
class ExecuteQuoteResponseModel with _$ExecuteQuoteResponseModel {
  const factory ExecuteQuoteResponseModel({
    required bool isFromFixed,
    required bool isExecuted,
    required String operationId,
    required double price,
    @JsonKey(name: 'fromAsset') required String fromAssetSymbol,
    @JsonKey(name: 'toAsset') required String toAssetSymbol,
    @JsonKey(name: 'fromAssetVolume') required double fromAssetAmount,
    @JsonKey(name: 'toAssetVolume') required double toAssetAmount,
    @JsonKey(name: 'actualTimeInSecond') required int expirationTime,
  }) = _ExecuteQuoteResponseModel;

  factory ExecuteQuoteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExecuteQuoteResponseModelFromJson(json);
}
