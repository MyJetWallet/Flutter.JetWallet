import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_verification_response_model.freezed.dart';
part 'card_verification_response_model.g.dart';

@freezed
class CardVerificationResponseModel with _$CardVerificationResponseModel {
  const factory CardVerificationResponseModel({
    required CardVerificationResponseDataModel data,
  }) = _CardVerificationResponseModel;

  factory CardVerificationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CardVerificationResponseModelFromJson(json);
}

@freezed
class CardVerificationResponseDataModel
    with _$CardVerificationResponseDataModel {
  const factory CardVerificationResponseDataModel({
    String? cardId,
    CardVerificationState? verificationState,
  }) = _CardVerificationResponseDataModel;

  factory CardVerificationResponseDataModel.fromJson(
          Map<String, dynamic> json) =>
      _$CardVerificationResponseDataModelFromJson(json);
}

enum CardVerificationState {
  @JsonValue(0)
  inProgress,
  @JsonValue(1)
  success,
  @JsonValue(2)
  fail,
  @JsonValue(3)
  blocked,
}
