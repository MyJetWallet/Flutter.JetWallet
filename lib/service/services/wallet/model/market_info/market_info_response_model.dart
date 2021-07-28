import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_info_response_model.freezed.dart';
part 'market_info_response_model.g.dart';

@freezed
class MarketInfoResponseModel with _$MarketInfoResponseModel {
  const factory MarketInfoResponseModel({
    required String whitepaperUrl,
    required String officialWebsiteUrl,
    required double marketCap,
    required double supply,
    @JsonKey(name: 'volume24') required double dayVolume,
    required String aboutLess,
    required String aboutMore,
  }) = _MarketInfoResponseModel;

  factory MarketInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MarketInfoResponseModelFromJson(json);
}
