import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'calculate_earn_offer_apy_response_model.freezed.dart';
part 'calculate_earn_offer_apy_response_model.g.dart';

@freezed
class CalculateEarnOfferApyResponseModel with _$CalculateEarnOfferApyResponseModel {
  const factory CalculateEarnOfferApyResponseModel({
    String? offerId,
    List<TierModel>? tiers,
    @DecimalSerialiser() required Decimal amount,
    @DecimalSerialiser() required Decimal apy,
    @DecimalSerialiser() required Decimal currentApy,
    @DecimalSerialiser() required Decimal currentBalance,
    @DecimalSerialiser() required Decimal expectedYearlyProfit,
    @DecimalSerialiser() required Decimal expectedDailyProfit,
    @DecimalSerialiser() required Decimal expectedYearlyProfitBaseAsset,
    @DecimalSerialiser() required Decimal expectedDailyProfitBaseAsset,
    @DecimalSerialiser() required Decimal maxSubscribeAmount,
    @DecimalSerialiser() required Decimal minSubscribeAmount,
    required bool amountTooLarge,
    required bool amountTooLow,
  }) = _CalculateEarnOfferApyResponseModel;

  factory CalculateEarnOfferApyResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CalculateEarnOfferApyResponseModelFromJson(json);
}

@freezed
class TierModel with _$TierModel {
  const factory TierModel({
    @DecimalSerialiser() required Decimal fromUsd,
    @DecimalSerialiser() required Decimal toUsd,
    @DecimalSerialiser() required Decimal from,
    @DecimalSerialiser() required Decimal to,
    @DecimalSerialiser() required Decimal apy,
    required bool active,
  }) = _TierModel;

  factory TierModel.fromJson(Map<String, dynamic> json) => _$TierModelFromJson(json);
}
