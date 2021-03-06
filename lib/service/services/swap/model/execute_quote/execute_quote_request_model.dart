import 'package:freezed_annotation/freezed_annotation.dart';

part 'execute_quote_request_model.freezed.dart';
part 'execute_quote_request_model.g.dart';

@freezed
class ExecuteQuoteRequestModel with _$ExecuteQuoteRequestModel {
  const factory ExecuteQuoteRequestModel({
    required String operationId,
    required double price,
    required String fromAsset,
    required String toAsset,
    @JsonKey(name: 'fromAssetVolume') required double fromAssetAmount,
    @JsonKey(name: 'toAssetVolume') required double toAssetAmount,
    required bool isFromFixed,
  }) = _ExecuteQuoteRequestModel;

  factory ExecuteQuoteRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ExecuteQuoteRequestModelFromJson(json);
}
