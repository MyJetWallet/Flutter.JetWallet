import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_add_response_model.freezed.dart';
part 'card_add_response_model.g.dart';

@freezed
class CardAddResponseModel with _$CardAddResponseModel {
  const factory CardAddResponseModel({
    required CardAddResponseDataModel data,
  }) = _CardAddResponseModel;

  factory CardAddResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CardAddResponseModelFromJson(json);
}

@freezed
class CardAddResponseDataModel with _$CardAddResponseDataModel {
  const factory CardAddResponseDataModel({
    String? cardId,
    CardStatus? status,
    CardVerificationType? requiredVerification,
    @Default(false) bool showUaAlert,
  }) = _CardAddResponseDataModel;

  factory CardAddResponseDataModel.fromJson(Map<String, dynamic> json) =>
      _$CardAddResponseDataModelFromJson(json);
}

enum CardStatus {
  @JsonValue(0)
  verificationRequired,
  @JsonValue(1)
  accepted,
  @JsonValue(2)
  blocked,
}

enum CardVerificationType {
  @JsonValue(0)
  none,
  @JsonValue(1)
  cardCheck,
  @JsonValue(2)
  cardWithSelfieCheck,
}
