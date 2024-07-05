import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_info_request_model.freezed.dart';
part 'market_info_request_model.g.dart';

@freezed
class MarketInfoRequestModel with _$MarketInfoRequestModel {
  const factory MarketInfoRequestModel({
    required String assetId,
    @JsonKey(name: 'lang') required String language,
  }) = _MarketInfoRequestModel;

  factory MarketInfoRequestModel.fromJson(Map<String, dynamic> json) => _$MarketInfoRequestModelFromJson(json);
}
