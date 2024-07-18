import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_news_request_model.freezed.dart';
part 'market_news_request_model.g.dart';

@freezed
class MarketNewsRequestModel with _$MarketNewsRequestModel {
  const factory MarketNewsRequestModel({
    required String assetId,
    required DateTime lastSeen,
    @JsonKey(name: 'lang') required String language,
    @JsonKey(name: 'take') required int amount,
  }) = _MarketNewsRequestModel;

  factory MarketNewsRequestModel.fromJson(Map<String, dynamic> json) => _$MarketNewsRequestModelFromJson(json);
}
