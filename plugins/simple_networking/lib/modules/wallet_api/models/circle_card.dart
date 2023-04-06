import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'circle_card.freezed.dart';
part 'circle_card.g.dart';

@freezed
class CircleCard with _$CircleCard {
  const factory CircleCard({
    required String id,
    required String last4,
    required String network,
    required int expMonth,
    required int expYear,
    required CircleCardStatus status,
    IntegrationType? integration,
    @Default(false) bool showUaAlert,
    required bool lastUsed,
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

enum IntegrationType {
  @JsonValue(0)
  circle,
  @JsonValue(1)
  unlimint,
  @JsonValue(2)
  unlimintAlt,
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
    @DecimalSerialiser() required Decimal minAmount,
    @DecimalSerialiser() required Decimal maxAmount,
    @DecimalSerialiser() required Decimal feePercentage,
  }) = _CircleCardInfoPayment;

  factory CircleCardInfoPayment.fromJson(Map<String, dynamic> json) =>
      _$CircleCardInfoPaymentFromJson(json);
}
