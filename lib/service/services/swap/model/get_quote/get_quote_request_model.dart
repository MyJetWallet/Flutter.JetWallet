import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_quote_request_model.freezed.dart';
part 'get_quote_request_model.g.dart';

@freezed
class GetQuoteRequestModel with _$GetQuoteRequestModel {
  const factory GetQuoteRequestModel({
    @JsonKey(name: 'fromAssetVolume') double? fromAssetAmount,
    @JsonKey(name: 'toAssetVolume') double? toAssetAmount,
    required String fromAsset,
    required String toAsset,
    required bool isFromFixed,
  }) = _GetQuoteRequestModel;

  factory GetQuoteRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GetQuoteRequestModelFromJson(json);
}
