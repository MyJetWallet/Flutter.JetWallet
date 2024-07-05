import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_check_response_model.freezed.dart';
part 'card_check_response_model.g.dart';

@freezed
class CardCheckResponseModel with _$CardCheckResponseModel {
  const factory CardCheckResponseModel({
    required CardCheckResponseDataModel data,
  }) = _CardCheckResponseModel;

  factory CardCheckResponseModel.fromJson(Map<String, dynamic> json) => _$CardCheckResponseModelFromJson(json);
}

@freezed
class CardCheckResponseDataModel with _$CardCheckResponseDataModel {
  const factory CardCheckResponseDataModel({
    String? verificationId,
    VerificationStarted? verificationStarted,
  }) = _CardCheckResponseDataModel;

  factory CardCheckResponseDataModel.fromJson(Map<String, dynamic> json) => _$CardCheckResponseDataModelFromJson(json);
}

enum VerificationStarted {
  @JsonValue(0)
  notStarted,
  @JsonValue(1)
  inProgress,
}
