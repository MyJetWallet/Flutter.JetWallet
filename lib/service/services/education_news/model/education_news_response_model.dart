import 'package:freezed_annotation/freezed_annotation.dart';

part 'education_news_response_model.freezed.dart';
part 'education_news_response_model.g.dart';

@freezed
class EducationNewsResponseModel with _$EducationNewsResponseModel {
  const factory EducationNewsResponseModel({
    required List<EducationNewsModel> news,
  }) = _EducationNewsResponseModel;

  factory EducationNewsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$EducationNewsResponseModelFromJson(json);
}

@freezed
class EducationNewsModel with _$EducationNewsModel {
  const factory EducationNewsModel({
    required String source,
    required String topic,
    required String lang,
    required String timestamp,
    required String urlAddress,
    required Sentiment sentiment,
    required List<String> associatedAssets,
    required String description,
  }) = _EducationNewsModel;

  factory EducationNewsModel.fromJson(Map<String, dynamic> json) =>
      _$EducationNewsModelFromJson(json);
}

enum Sentiment {
@JsonValue('Neutral')
neutral,
@JsonValue('Positive')
positive,
@JsonValue('Negative')
negative,
}
