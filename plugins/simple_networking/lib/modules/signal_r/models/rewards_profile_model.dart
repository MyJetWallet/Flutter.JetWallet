import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'rewards_profile_model.freezed.dart';
part 'rewards_profile_model.g.dart';

@freezed
class RewardsProfileModel with _$RewardsProfileModel {
  factory RewardsProfileModel({
    final String? referralCode,
    final String? referralLink,
    final int? availableSpins,
    @DecimalNullSerialiser() final Decimal? totalEarnedUsd,
    @DecimalNullSerialiser() final Decimal? totalEarnedBaseCurrency,
    final String? titleText,
    final String? descriptionText,
    final List<RewardsBalance>? balances,
  }) = _RewardsProfileModel;

  factory RewardsProfileModel.fromJson(Map<String, dynamic> json) =>
      _$RewardsProfileModelFromJson(json);
}

@freezed
class RewardsBalance with _$RewardsBalance {
  const factory RewardsBalance({
    String? assetSymbol,
    @DecimalSerialiser() required Decimal amount,
  }) = _RewardsBalance;

  factory RewardsBalance.fromJson(Map<String, dynamic> json) =>
      _$RewardsBalanceFromJson(json);
}
