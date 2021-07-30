import 'package:freezed_annotation/freezed_annotation.dart';

part 'execute_quote_request_model.freezed.dart';
part 'execute_quote_request_model.g.dart';

@freezed
class ExecuteQuoteRequestModel with _$ExecuteQuoteRequestModel {
  const factory ExecuteQuoteRequestModel({
    @Default(true) bool isFromFixed,
    required String operationId,
    required double price,
    @JsonKey(name: 'fromAsset') required String fromAssetSymbol,
    @JsonKey(name: 'toAsset') required String toAssetSymbol,
    @JsonKey(name: 'fromAssetVolume') required double fromAssetAmount,
    @JsonKey(name: 'toAssetVolume') required double toAssetAmount,
  }) = _ExecuteQuoteRequestModel;

  factory ExecuteQuoteRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ExecuteQuoteRequestModelFromJson(json);
}
