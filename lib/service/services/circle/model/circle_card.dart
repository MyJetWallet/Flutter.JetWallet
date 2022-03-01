import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_card.freezed.dart';

@freezed
class CircleCard with _$CircleCard {
  const factory CircleCard({
    required String id,
    required String cardName,
    required String last4,
    required String network,
    required int expMonth,
    required int expYear,
    required CircleCardStatus status,
    required CircleCardVerificationError error,
    required bool isActive,
    required DateTime createDate,
    required DateTime updateDate,
    required CircleCardInfoPayment paymentDetails,
  }) = _CircleCard;

  factory CircleCard.fromJson(Map<String, dynamic> json) =>
      _$CircleCardFromJson(json);
}

enum CircleCardStatus {
  @JsonValue(0)
  pending,
  @JsonValue(1)
  complete,
  @JsonValue(2)
  failed,
}

enum CircleCardVerificationError {
  @JsonValue(0)
  cardFailed,
  @JsonValue(1)
  cardAddressMismatch,
  @JsonValue(2)
  cardZipMismatch,
  @JsonValue(3)
  cardCvvInvalid,
  @JsonValue(4)
  cardExpired,
}

@freezed
class CircleCardInfoPayment with _$CircleCardInfoPayment {
  const factory CircleCardInfoPayment({
    required double feePercentage,
    required double minAmount,
    required double maxAmount,
    required String settlementAsset,
  }) = _CircleCardInfoPayment;

  factory CircleCardInfoPayment.fromJson(Map<String, dynamic> json) =>
      _$CircleCardInfoPaymentFromJson(json);
}
