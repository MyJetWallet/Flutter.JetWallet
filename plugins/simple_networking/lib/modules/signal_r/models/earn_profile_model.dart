import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'earn_profile_model.freezed.dart';
part 'earn_profile_model.g.dart';

@freezed
class EarnProfileModel with _$EarnProfileModel {
  const factory EarnProfileModel({
    @DecimalSerialiser() required Decimal earnBalance,
    @DecimalSerialiser() required Decimal averageApy,
    @DecimalSerialiser() required Decimal totalInterestEarned,
    @DecimalSerialiser() required Decimal dayEarnProfit,
    @DecimalSerialiser() required Decimal yearEarnProfit,
    required bool earnEnabled,
  }) = _EarnProfileModel;

  factory EarnProfileModel.fromJson(Map<String, dynamic> json) => _$EarnProfileModelFromJson(json);
}
