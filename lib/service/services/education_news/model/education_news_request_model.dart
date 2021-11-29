import 'package:freezed_annotation/freezed_annotation.dart';

part 'education_news_request_model.freezed.dart';
part 'education_news_request_model.g.dart';

@freezed
class EducationNewsRequestModel with _$EducationNewsRequestModel {
  const factory EducationNewsRequestModel({
    required String lastSeen,
    @JsonKey(name: 'lang') required String language,
    @JsonKey(name: 'take') required int amount,
  }) = _EducationNewsRequestModel;

  factory EducationNewsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EducationNewsRequestModelFromJson(json);
}
