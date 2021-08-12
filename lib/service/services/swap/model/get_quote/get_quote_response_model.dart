import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_quote_response_model.freezed.dart';
part 'get_quote_response_model.g.dart';

@freezed
class GetQuoteResponseModel with _$GetQuoteResponseModel {
  const factory GetQuoteResponseModel({
    required bool isFromFixed,
    required String operationId,
    required double price,
    @JsonKey(name: 'fromAsset') required String fromAssetSymbol,
    @JsonKey(name: 'toAsset') required String toAssetSymbol,
    @JsonKey(name: 'fromAssetVolume') required double fromAssetAmount,
    @JsonKey(name: 'toAssetVolume') required double toAssetAmount,
    @JsonKey(name: 'actualTimeInSecond') required int expirationTime,
  }) = _GetQuoteResponseModel;

  factory GetQuoteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetQuoteResponseModelFromJson(json);
}
