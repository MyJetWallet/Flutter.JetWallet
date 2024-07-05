import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';
import 'package:simple_networking/modules/wallet_api/models/p2p_methods/p2p_payment_data.dart';

part 'card_buy_create_request_model.freezed.dart';
part 'card_buy_create_request_model.g.dart';

@freezed
class CardBuyCreateRequestModel with _$CardBuyCreateRequestModel {
  const factory CardBuyCreateRequestModel({
    @DecimalNullSerialiser() Decimal? paymentAmount,
    required String paymentAsset,
    required String buyAsset,
    @DecimalNullSerialiser() Decimal? buyAmount,
    required bool buyFixed,
    required CirclePaymentMethod paymentMethod,
    CirclePaymentDataModel? circlePaymentData,
    CirclePaymentDataModel? unlimintPaymentData,
    CirclePaymentDataModel? cardPaymentData,
    IbanPaymentPreview? ibanPaymentData,
    P2PPaymentData? p2PPaymentData,
  }) = _CardBuyCreateRequestModel;

  factory CardBuyCreateRequestModel.fromJson(Map<String, dynamic> json) => _$CardBuyCreateRequestModelFromJson(json);
}

@freezed
class CirclePaymentDataModel with _$CirclePaymentDataModel {
  const factory CirclePaymentDataModel({
    required String cardId,
  }) = _CirclePaymentDataModel;

  factory CirclePaymentDataModel.fromJson(Map<String, dynamic> json) => _$CirclePaymentDataModelFromJson(json);
}

@freezed
class IbanPaymentPreview with _$IbanPaymentPreview {
  const factory IbanPaymentPreview({
    required String accountId,
  }) = _IbanPaymentPreview;

  factory IbanPaymentPreview.fromJson(Map<String, dynamic> json) => _$IbanPaymentPreviewFromJson(json);
}

enum CirclePaymentMethod {
  @JsonValue(0)
  circle,
  @JsonValue(1)
  unlimint,
  @JsonValue(2)
  unlimintAlr,
  @JsonValue(3)
  bankCard,
  @JsonValue(4)
  applePay,
  @JsonValue(5)
  googlePay,
  @JsonValue(6)
  ibanTransferUnlimint,
  @JsonValue(102)
  pix,
  @JsonValue(103)
  picpay,
  @JsonValue(104)
  convenienceStore,
  @JsonValue(105)
  codi,
  @JsonValue(106)
  spei,
  @JsonValue(107)
  oxxo,
  @JsonValue(108)
  efecty,
  @JsonValue(109)
  baloto,
  @JsonValue(110)
  davivienda,
  @JsonValue(111)
  pagoEfectivo,
  @JsonValue(112)
  directBankingEurope,
  @JsonValue(300)
  paymeP2P
}
