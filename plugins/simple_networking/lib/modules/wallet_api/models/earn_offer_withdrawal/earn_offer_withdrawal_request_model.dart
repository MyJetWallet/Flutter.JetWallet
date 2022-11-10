import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'earn_offer_withdrawal_request_model.freezed.dart';
part 'earn_offer_withdrawal_request_model.g.dart';

@freezed
class EarnOfferWithdrawalRequestModel with _$EarnOfferWithdrawalRequestModel {
  const factory EarnOfferWithdrawalRequestModel({
    required String requestId,
    required String offerId,
    required String assetSymbol,
    @DecimalSerialiser() required Decimal amount,
  }) = _EarnOfferWithdrawalRequestModel;

  factory EarnOfferWithdrawalRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EarnOfferWithdrawalRequestModelFromJson(json);
}
