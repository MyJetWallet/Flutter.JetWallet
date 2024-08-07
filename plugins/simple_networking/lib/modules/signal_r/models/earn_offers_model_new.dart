import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'earn_offers_model_new.freezed.dart';
part 'earn_offers_model_new.g.dart';

@freezed
class ActiveEarnOffersMessage with _$ActiveEarnOffersMessage {
  const factory ActiveEarnOffersMessage({
    required List<EarnOfferClientModel> offers,
  }) = _ActiveEarnOffersMessage;

  factory ActiveEarnOffersMessage.fromJson(Map<String, dynamic> json) => _$ActiveEarnOffersMessageFromJson(json);
}

@freezed
class EarnOfferClientModel with _$EarnOfferClientModel {
  const factory EarnOfferClientModel({
    required String id,
    String? name,
    String? description,
    required String assetId,
    @Default(EarnOfferStatus.undefined) @JsonKey(unknownEnumValue: EarnOfferStatus.undefined) EarnOfferStatus status,
    @Default(WithdrawType.undefined) @JsonKey(unknownEnumValue: WithdrawType.undefined) WithdrawType withdrawType,
    @DecimalNullSerialiser() Decimal? apyRate,
    int? paymentPeriodDays,
    @DecimalNullSerialiser() Decimal? minAmount,
    int? lockPeriod,
    @Default(false) bool promotion,
  }) = _EarnOfferClientModel;

  factory EarnOfferClientModel.fromJson(Map<String, dynamic> json) => _$EarnOfferClientModelFromJson(json);
}

enum EarnOfferStatus {
  @JsonValue(0)
  undefined,
  @JsonValue(1)
  activeShow,
  @JsonValue(2)
  activeHide,
  @JsonValue(3)
  closed,
}

enum WithdrawType {
  @JsonValue(0)
  undefined,
  @JsonValue(1)
  instant,
  @JsonValue(2)
  lock,
}
