import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/decimal_serialiser.dart';

part 'earn_offer_deposit_request_model.freezed.dart';
part 'earn_offer_deposit_request_model.g.dart';

@freezed
class EarnOfferDepositRequestModel with _$EarnOfferDepositRequestModel {
  const factory EarnOfferDepositRequestModel({
    required String requestId,
    required String offerId,
    required String offerAssetSymbol,
    required String baseAssetSymbol,
    @DecimalSerialiser() required Decimal amount,
  }) = _EarnOfferDepositRequestModel;

  factory EarnOfferDepositRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EarnOfferDepositRequestModelFromJson(json);
}
