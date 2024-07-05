import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

import 'earn_profile_model.dart';

part 'earn_offers_model.freezed.dart';
part 'earn_offers_model.g.dart';

@freezed
class EarnFullModel with _$EarnFullModel {
  const factory EarnFullModel({
    required List<EarnOfferModel> earnOffers,
    EarnProfileModel? earnProfile,
  }) = _EarnFullModel;

  factory EarnFullModel.fromJson(Map<String, dynamic> json) => _$EarnFullModelFromJson(json);
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
    @DecimalSerialiser() required Decimal amountBaseAsset,
    @DecimalSerialiser() required Decimal currentApy,
    @DecimalSerialiser() required Decimal totalEarned,
    @DecimalSerialiser() required Decimal amount,
    @DecimalSerialiser() required Decimal maxAmount,
    required String term,
    required String offerTag,
    required List<TierApySettingsModel> tiers,
  }) = _EarnOfferModel;

  factory EarnOfferModel.fromJson(Map<String, dynamic> json) => _$EarnOfferModelFromJson(json);
}

@freezed
class TierApySettingsModel with _$TierApySettingsModel {
  const factory TierApySettingsModel({
    @DecimalSerialiser() required Decimal fromUsd,
    @DecimalSerialiser() required Decimal toUsd,
    @DecimalSerialiser() required Decimal from,
    @DecimalSerialiser() required Decimal to,
    @DecimalSerialiser() required Decimal apy,
    @DecimalSerialiser() required bool active,
  }) = _TierApySettingsModel;

  factory TierApySettingsModel.fromJson(Map<String, dynamic> json) => _$TierApySettingsModelFromJson(json);
}
