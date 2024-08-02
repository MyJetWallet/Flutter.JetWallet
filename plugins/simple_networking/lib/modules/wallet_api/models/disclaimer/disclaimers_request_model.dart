import 'package:freezed_annotation/freezed_annotation.dart';

part 'disclaimers_request_model.freezed.dart';
part 'disclaimers_request_model.g.dart';

@freezed
class DisclaimersRequestModel with _$DisclaimersRequestModel {
  const factory DisclaimersRequestModel({
    required String disclaimerId,
    required List<DisclaimerAnswersModel> answers,
  }) = _DisclaimersRequestModel;

  factory DisclaimersRequestModel.fromJson(Map<String, dynamic> json) => _$DisclaimersRequestModelFromJson(json);
}

@freezed
class DisclaimerAnswersModel with _$DisclaimerAnswersModel {
  const factory DisclaimerAnswersModel({
    required String clientId,
    required String disclaimerId,
    required String questionId,
    required bool result,
  }) = _DisclaimerAnswersModel;

  factory DisclaimerAnswersModel.fromJson(Map<String, dynamic> json) => _$DisclaimerAnswersModelFromJson(json);
}
