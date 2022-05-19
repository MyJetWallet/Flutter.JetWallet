import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'earn_offers_model.freezed.dart';
part 'earn_offers_model.g.dart';

@freezed
class EarnOffersModel with _$EarnOffersModel {
  const factory EarnOffersModel({
    required List<EarnOfferModel> earnOffers,
  }) = _EarnOffersModel;

  factory EarnOffersModel.fromJson(Map<String, dynamic> json) =>
      _$EarnOffersModelFromJson(json);
}

@freezed
class EarnOfferModel with _$EarnOfferModel {
  const factory EarnOfferModel({
    String? endDate,
    required String startDate,
    required String offerId,
    required String asset,
    required String title,
    required bool withdrawalEnabled,
    required bool topUpEnabled,
    required Decimal amountBaseAsset,
    required Decimal currentApy,
    required Decimal totalEarned,
    required Decimal amount,
    required Decimal maxAmount,
    required Term term,
    required OfferTag offerTag,
    required List<TierApySettingsModel> tiers,
  }) = _EarnOfferModel;

  factory EarnOfferModel.fromJson(Map<String, dynamic> json) =>
      _$EarnOfferModelFromJson(json);
}

@freezed
class TierApySettingsModel with _$TierApySettingsModel {
  const factory TierApySettingsModel({
    required Decimal fromUsd,
    required Decimal toUsd,
    required Decimal apy,
    required bool active,
  }) = _TierApySettingsModel;

  factory TierApySettingsModel.fromJson(Map<String, dynamic> json) =>
      _$TierApySettingsModelFromJson(json);
}

enum Term {
  @JsonValue(0)
  flexible,
}

enum OfferTag {
  @JsonValue(0)
  none,
  @JsonValue(1)
  hot,
}
