import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'earn_offer_request_model.freezed.dart';
part 'earn_offer_request_model.g.dart';

@freezed
class EarnOfferRequestModel with _$EarnOfferRequestModel {
  const factory EarnOfferRequestModel({
    required String requestId,
    required String offerId,
    required String assetId,
    @DecimalSerialiser() required Decimal amount,
  }) = _EarnOfferRequestModel;

  factory EarnOfferRequestModel.fromJson(Map<String, dynamic> json) => _$EarnOfferRequestModelFromJson(json);
}
