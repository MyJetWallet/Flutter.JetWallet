import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'earn_profile_model.freezed.dart';
part 'earn_profile_model.g.dart';

@freezed
class EarnProfileModel with _$EarnProfileModel {
  const factory EarnProfileModel({
    required Decimal earnBalance,
    required Decimal averrageApy,
    required Decimal totalInterestEarned,
    required Decimal dayEarnProfit,
    required Decimal yearEarnProfit,
  }) = _EarnProfileModel;

  factory EarnProfileModel.fromJson(Map<String, dynamic> json) =>
      _$EarnProfileModelFromJson(json);
}
