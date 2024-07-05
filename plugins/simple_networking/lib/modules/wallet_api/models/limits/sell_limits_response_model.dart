import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'sell_limits_response_model.freezed.dart';
part 'sell_limits_response_model.g.dart';

@freezed
class SellLimitsResponseModel with _$SellLimitsResponseModel {
  const factory SellLimitsResponseModel({
    required String paymentAsset,
    @DecimalSerialiser() required Decimal maxSellAmount,
    @DecimalSerialiser() required Decimal minSellAmount,
    required String buyAsset,
    @DecimalSerialiser() required Decimal maxBuyAmount,
    @DecimalSerialiser() required Decimal minBuyAmount,
  }) = _SellLimitsResponseModel;

  factory SellLimitsResponseModel.fromJson(Map<String, dynamic> json) => _$SellLimitsResponseModelFromJson(json);
}
