import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'simple_card_limits_responce.freezed.dart';
part 'simple_card_limits_responce.g.dart';

@freezed
class SimpleCardLimitsResponceModel with _$SimpleCardLimitsResponceModel {
  factory SimpleCardLimitsResponceModel({
    @DecimalNullSerialiser() Decimal? dailySpendingValue,
    @DecimalNullSerialiser() Decimal? dailySpendingLimit,
    @DecimalNullSerialiser() Decimal? dailyWithdrawalValue,
    @DecimalNullSerialiser() Decimal? dailyWithdrawalLimit,
    DateTime? dailyLimitsReset,
    @DecimalNullSerialiser() Decimal? monthlySpendingValue,
    @DecimalNullSerialiser() Decimal? monthlySpendingLimit,
    @DecimalNullSerialiser() Decimal? monthlyWithdrawalValue,
    @DecimalNullSerialiser() Decimal? monthlyWithdrawalLimit,
    DateTime? monthlyLimitsReset,
  }) = _SimpleCardLimitsResponceModel;

  factory SimpleCardLimitsResponceModel.fromJson(Map<String, dynamic> json) =>
      _$SimpleCardLimitsResponceModelFromJson(json);
}
