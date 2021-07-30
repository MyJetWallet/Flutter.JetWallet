import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_quote_request_model.freezed.dart';
part 'get_quote_request_model.g.dart';

@freezed
class GetQuoteRequestModel with _$GetQuoteRequestModel {
  const factory GetQuoteRequestModel({
    @Default(true) bool isFromFixed,
    @JsonKey(name: 'fromAssetVolume') double? fromAssetAmount,
    @JsonKey(name: 'toAssetVolume') double? toAssetAmount,
    @JsonKey(name: 'fromAsset') required String fromAssetSymbol,
    @JsonKey(name: 'toAsset') required String toAssetSymbol,
  }) = _GetQuoteRequestModel;

  factory GetQuoteRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GetQuoteRequestModelFromJson(json);
}
