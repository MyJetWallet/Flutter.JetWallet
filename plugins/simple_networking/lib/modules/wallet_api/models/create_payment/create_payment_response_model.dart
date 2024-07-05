import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_payment_response_model.freezed.dart';
part 'create_payment_response_model.g.dart';

@freezed
class CreatePaymentResponseModel with _$CreatePaymentResponseModel {
  const factory CreatePaymentResponseModel({
    required CirclePaymentStatus status,
    required int depositId,
  }) = _CreatePaymentResponseModel;

  factory CreatePaymentResponseModel.fromJson(Map<String, dynamic> json) => _$CreatePaymentResponseModelFromJson(json);
}

enum CirclePaymentStatus {
  @JsonValue(0)
  ok,
  @JsonValue(1)
  cardNotFound,
  @JsonValue(2)
  paymentFailed,
  @JsonValue(3)
  cardFailed,
  @JsonValue(4)
  cardAddressMismatch,
  @JsonValue(5)
  cardZipMismatch,
  @JsonValue(6)
  cardCvvInvalid,
  @JsonValue(7)
  cardExpired,
}
