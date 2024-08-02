import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_info_response_model.freezed.dart';
part 'payment_info_response_model.g.dart';

@freezed
class PaymentInfoResponseModel with _$PaymentInfoResponseModel {
  const factory PaymentInfoResponseModel({
    String? redirectedUrl,
    required PaymentStatus status,
  }) = _PaymentInfoResponseModel;

  factory PaymentInfoResponseModel.fromJson(Map<String, dynamic> json) => _$PaymentInfoResponseModelFromJson(json);
}

enum PaymentStatus {
  @JsonValue(0)
  pending,
  @JsonValue(1)
  confirmed,
  @JsonValue(2)
  complete,
  @JsonValue(3)
  paid,
  @JsonValue(4)
  failed,
  @JsonValue(5)
  actionRequired,
}
