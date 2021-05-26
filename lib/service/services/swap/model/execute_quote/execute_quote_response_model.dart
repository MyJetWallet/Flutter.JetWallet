import 'package:freezed_annotation/freezed_annotation.dart';

part 'execute_quote_response_model.freezed.dart';
part 'execute_quote_response_model.g.dart';

@freezed
class ExecuteQuoteResponseModel with _$ExecuteQuoteResponseModel {
  const factory ExecuteQuoteResponseModel({
    required bool isExecuted,
    required String operationId,
    required int price,
    required String fromAsset,
    required String toAsset,
    @JsonKey(name: 'fromAssetVolume') required int fromAssetAmount,
    @JsonKey(name: 'toAssetVolume') required int toAssetAmount,
    required bool isFromFixed,
  }) = _ExecuteQuoteResponseModel;

  factory ExecuteQuoteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExecuteQuoteResponseModelFromJson(json);
}
