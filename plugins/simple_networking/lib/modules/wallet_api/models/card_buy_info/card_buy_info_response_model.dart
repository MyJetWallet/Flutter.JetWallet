import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'card_buy_info_response_model.freezed.dart';
part 'card_buy_info_response_model.g.dart';

@freezed
class CardBuyInfoResponseModel with _$CardBuyInfoResponseModel {
  const factory CardBuyInfoResponseModel({
    String? paymentId,
    required CardBuyPaymentStatus status,
    ClientActionModel? clientAction,
    PaymentInfoModel? paymentInfo,
    BuyInfoModel? buyInfo,
    String? rejectCode,
  }) = _CardBuyInfoResponseModel;

  factory CardBuyInfoResponseModel.fromJson(Map<String, dynamic> json) => _$CardBuyInfoResponseModelFromJson(json);
}

@freezed
class ClientActionModel with _$ClientActionModel {
  const factory ClientActionModel({
    String? checkoutUrl,
    required List<String> redirectUrls,
    String? threeDSecureUrl,
  }) = _ClientActionModel;

  factory ClientActionModel.fromJson(Map<String, dynamic> json) => _$ClientActionModelFromJson(json);
}

@freezed
class PaymentInfoModel with _$PaymentInfoModel {
  const factory PaymentInfoModel({
    @DecimalSerialiser() required Decimal paymentAmount,
    String? paymentAsset,
    @DecimalSerialiser() required Decimal depositFeeAmount,
    String? depositFeeAsset,
    @DecimalSerialiser() required Decimal tradeFeeAmount,
    String? tradeFeeAsset,
  }) = _PaymentInfoModel;

  factory PaymentInfoModel.fromJson(Map<String, dynamic> json) => _$PaymentInfoModelFromJson(json);
}

@freezed
class BuyInfoModel with _$BuyInfoModel {
  const factory BuyInfoModel({
    String? buyAsset,
    @DecimalSerialiser() required Decimal buyAmount,
    @DecimalSerialiser() required Decimal rate,
  }) = _BuyInfoModel;

  factory BuyInfoModel.fromJson(Map<String, dynamic> json) => _$BuyInfoModelFromJson(json);
}

enum CardBuyPaymentStatus {
  @JsonValue(0)
  preview,
  @JsonValue(1)
  inProcess,
  @JsonValue(2)
  requireAction,
  @JsonValue(3)
  waitForPayment,
  @JsonValue(4)
  success,
  @JsonValue(5)
  fail,
}
