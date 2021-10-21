import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_response_model.freezed.dart';
part 'news_response_model.g.dart';

@freezed
class NewsResponseModel with _$NewsResponseModel {
  const factory NewsResponseModel({
    required List<NewsModel> news,
  }) = _NewsResponseModel;

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseModelFromJson(json);
}

@freezed
class NewsModel with _$NewsModel {
  const factory NewsModel({
    required String source,
    required String topic,
    required String lang,
    required String timestamp,
    required String urlAddress,
    required Sentiment sentiment,
    required List<String> associatedAssets,
  }) = _NewsModel;

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);
}

enum Sentiment {
  @JsonValue('Neutral')
  neutral,
  @JsonValue('Positive')
  positive,
  @JsonValue('Negative')
  negative,
}
