import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'buy_limits_response_model.freezed.dart';
part 'buy_limits_response_model.g.dart';

@freezed
class BuyLimitsResponseModel with _$BuyLimitsResponseModel {
  const factory BuyLimitsResponseModel({
    required String paymentAsset,
    @DecimalSerialiser() required Decimal maxSellAmount,
    @DecimalSerialiser() required Decimal minSellAmount,
    required String buyAsset,
    @DecimalSerialiser() required Decimal maxBuyAmount,
    @DecimalSerialiser() required Decimal minBuyAmount,

  }) = _BuyLimitsResponseModel;

  factory BuyLimitsResponseModel.fromJson(Map<String, dynamic> json) => _$BuyLimitsResponseModelFromJson(json);
}
