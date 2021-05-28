import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_quote_response_model.freezed.dart';
part 'get_quote_response_model.g.dart';

@freezed
class GetQuoteResponseModel with _$GetQuoteResponseModel {
  const factory GetQuoteResponseModel({
    required String operationId,
    required double price,
    required String fromAsset,
    required String toAsset,
    @JsonKey(name: 'fromAssetVolume') required double fromAssetAmount,
    @JsonKey(name: 'toAssetVolume') required double toAssetAmount,
    required bool isFromFixed,
    @JsonKey(name: 'actualTimeInSecond') required int expirationTime,
  }) = _GetQuoteResponseModel;

  factory GetQuoteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetQuoteResponseModelFromJson(json);
}
