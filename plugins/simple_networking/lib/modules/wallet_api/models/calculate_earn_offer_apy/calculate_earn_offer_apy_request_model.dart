import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'calculate_earn_offer_apy_request_model.freezed.dart';
part 'calculate_earn_offer_apy_request_model.g.dart';

@freezed
class CalculateEarnOfferApyRequestModel with _$CalculateEarnOfferApyRequestModel {
  const factory CalculateEarnOfferApyRequestModel({
    required String offerId,
    required String assetSymbol,
    @DecimalSerialiser() required Decimal amount,
  }) = _CalculateEarnOfferApyRequestModel;

  factory CalculateEarnOfferApyRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CalculateEarnOfferApyRequestModelFromJson(json);
}
