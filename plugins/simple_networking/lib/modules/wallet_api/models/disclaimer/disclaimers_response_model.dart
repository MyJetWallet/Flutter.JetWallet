import 'package:freezed_annotation/freezed_annotation.dart';

part 'disclaimers_response_model.freezed.dart';
part 'disclaimers_response_model.g.dart';

@freezed
class DisclaimersResponseModel with _$DisclaimersResponseModel {
  const factory DisclaimersResponseModel({
    List<DisclaimerModel>? disclaimers,
  }) = _DisclaimersResponseModel;

  factory DisclaimersResponseModel.fromJson(Map<String, dynamic> json) => _$DisclaimersResponseModelFromJson(json);
}

@freezed
class DisclaimerModel with _$DisclaimerModel {
  const factory DisclaimerModel({
    String? imageUrl,
    required String disclaimerId,
    required String title,
    required String description,
    required List<DisclaimerQuestionsModel> questions,
  }) = _DisclaimerModel;

  factory DisclaimerModel.fromJson(Map<String, dynamic> json) => _$DisclaimerModelFromJson(json);
}

@freezed
class DisclaimerQuestionsModel with _$DisclaimerQuestionsModel {
  const factory DisclaimerQuestionsModel({
    required String questionId,
    required String text,
    required bool required,
    required bool defaultState,
  }) = _DisclaimerQuestionsModel;

  factory DisclaimerQuestionsModel.fromJson(Map<String, dynamic> json) => _$DisclaimerQuestionsModelFromJson(json);
}
