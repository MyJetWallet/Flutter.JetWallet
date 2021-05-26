import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_quote_request_model.freezed.dart';
part 'get_quote_request_model.g.dart';

@freezed
class GetQuoteRequestModel with _$GetQuoteRequestModel {
  const factory GetQuoteRequestModel({
    required String fromAsset,
    required String toAsset,
    @JsonKey(name: 'fromAssetVolume') required int fromAssetAmount,
    @JsonKey(name: 'toAssetVolume') required int toAssetAmount,
    required bool isFromFixed,
  }) = _GetQuoteRequestModel;

  factory GetQuoteRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GetQuoteRequestModelFromJson(json);
}
