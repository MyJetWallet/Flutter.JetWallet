import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'limits_crypto_card_response_model.freezed.dart';
part 'limits_crypto_card_response_model.g.dart';

@freezed
class LimitsCryptoCardResponseModel with _$LimitsCryptoCardResponseModel {
  const factory LimitsCryptoCardResponseModel({
    @DecimalSerialiser() required Decimal atmDailyUsed,
    @DecimalSerialiser() required Decimal atmDailyLimit,
    @DecimalSerialiser() required Decimal atmWeeklyUsed,
    @DecimalSerialiser() required Decimal atmWeeklyLimit,
    @DecimalSerialiser() required Decimal atmMonthlyUsed,
    @DecimalSerialiser() required Decimal atmMonthlyLimit,
    @DecimalSerialiser() required Decimal purchaseDailyUsed,
    @DecimalSerialiser() required Decimal purchaseDailyLimit,
    @DecimalSerialiser() required Decimal purchaseWeeklyUsed,
    @DecimalSerialiser() required Decimal purchaseWeeklyLimit,
    @DecimalSerialiser() required Decimal purchaseMonthlyUsed,
    @DecimalSerialiser() required Decimal purchaseMonthlyLimit,
  }) = _LimitsCryptoCardResponseModel;

  factory LimitsCryptoCardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LimitsCryptoCardResponseModelFromJson(json);
}
