import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_news_response_model.freezed.dart';
part 'market_news_response_model.g.dart';

@freezed
class MarketNewsResponseModel with _$MarketNewsResponseModel {
  const factory MarketNewsResponseModel({
    required List<MarketNewsModel> news,
  }) = _MarketNewsResponseModel;

  factory MarketNewsResponseModel.fromJson(Map<String, dynamic> json) => _$MarketNewsResponseModelFromJson(json);
}

@freezed
class MarketNewsModel with _$MarketNewsModel {
  const factory MarketNewsModel({
    required String source,
    required String topic,
    required String description,
    required String lang,
    required DateTime timestamp,
    required String urlAddress,
    required List<String> associatedAssets,
    String? imageUrl,
    required Sentiment sentiment,
    required String integrationSource,
  }) = _MarketNewsModel;

  factory MarketNewsModel.fromJson(Map<String, dynamic> json) => _$MarketNewsModelFromJson(json);
}

enum Sentiment {
  @JsonValue('Neutral')
  neutral,
  @JsonValue('Positive')
  positive,
  @JsonValue('Negative')
  negative,
}
