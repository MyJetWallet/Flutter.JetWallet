import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_payment_methods.freezed.dart';
part 'asset_payment_methods.g.dart';

@freezed
class AssetPaymentMethods with _$AssetPaymentMethods {
  const factory AssetPaymentMethods({
    required List<AssetPaymentInfo> assets,
    @Default(false) bool showCardsInProfile,
  }) = _AssetPaymentMethods;

  factory AssetPaymentMethods.fromJson(Map<String, dynamic> json) =>
      _$AssetPaymentMethodsFromJson(json);
}

@freezed
class AssetPaymentInfo with _$AssetPaymentInfo {
  const factory AssetPaymentInfo({
    required String symbol,
    required List<PaymentMethod> buyMethods,
    required List<PaymentMethod> depositMethods,
    required List<PaymentMethod> withdrawalMethods,
  }) = _AssetPaymentInfo;

  factory AssetPaymentInfo.fromJson(Map<String, dynamic> json) =>
      _$AssetPaymentInfoFromJson(json);
}

@freezed
class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    @PaymentTypeSerialiser()
    @JsonKey(name: 'name')
    required PaymentMethodType type,
    required double minAmount,
    required double maxAmount,
    required double availableAmount,
  }) = _PaymentMethod;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
}

enum PaymentMethodCategory {
  p2p,
  cards,
  local,
  account,
}

enum PaymentMethodType {
  simplex,
  circleCard,
  unlimintCard,
  unsupported,
  unlimintAlternative,
  bankCard,
  applePay,
  googlePay,
  globalSend,
  depositExpressBrasil,
  pix,
  picpay,
  convenienceStore,
  codi,
  spei,
  oxxo,
  efecty,
  baloto,
  davivienda,
  pagoEfectivo,
  directBankingEurope,
  boleto,
  bpppix,
  qrcode3166,
  daviviendabank,
  paymeP2P,
}

extension _PaymentMethodTypeExtension on PaymentMethodType {
  String get name {
    switch (this) {
      case PaymentMethodType.simplex:
        return 'Simplex';
      case PaymentMethodType.circleCard:
        return 'CircleCard';
      case PaymentMethodType.unlimintCard:
        return 'UnlimintCard';
      case PaymentMethodType.unlimintAlternative:
        return 'UnlimintAlternative';
      case PaymentMethodType.bankCard:
        return 'BankCard';
      case PaymentMethodType.applePay:
        return 'UnlimintApplePay';
      case PaymentMethodType.googlePay:
        return 'UnlimintGooglePay';
      case PaymentMethodType.globalSend:
        return 'GlobalSend';
      case PaymentMethodType.depositExpressBrasil:
        return 'DepositExpressBrasil';
      case PaymentMethodType.pix:
        return 'Pix';
      case PaymentMethodType.picpay:
        return 'Picpay';
      case PaymentMethodType.convenienceStore:
        return 'ConvenienceStore';
      case PaymentMethodType.codi:
        return 'Codi';
      case PaymentMethodType.spei:
        return 'Spei';
      case PaymentMethodType.oxxo:
        return 'Oxxo';
      case PaymentMethodType.efecty:
        return 'Efecty';
      case PaymentMethodType.baloto:
        return 'Baloto';
      case PaymentMethodType.davivienda:
        return 'Davivienda';
      case PaymentMethodType.pagoEfectivo:
        return 'PagoEfectivo';
      case PaymentMethodType.directBankingEurope:
        return 'DirectBankingEurope';
      case PaymentMethodType.boleto:
        return 'Boleto';
      case PaymentMethodType.bpppix:
        return 'bpppix';
      case PaymentMethodType.qrcode3166:
        return 'qrcode3166';
      case PaymentMethodType.daviviendabank:
        return 'daviviendabank';
      case PaymentMethodType.paymeP2P:
        return 'PaymeP2P';
      default:
        return 'Unsupported';
    }
  }
}

class PaymentTypeSerialiser
    implements JsonConverter<PaymentMethodType, dynamic> {
  const PaymentTypeSerialiser();

  @override
  PaymentMethodType fromJson(dynamic json) {
    final value = json.toString();

    if (value == 'Simplex') {
      return PaymentMethodType.simplex;
    } else if (value == 'CircleCard') {
      return PaymentMethodType.circleCard;
    } else if (value == 'UnlimintCard') {
      return PaymentMethodType.unlimintCard;
    } else if (value == 'Unlimint') {
      return PaymentMethodType.unlimintCard;
    } else if (value == 'UnlimintAlternative') {
      return PaymentMethodType.unlimintAlternative;
    } else if (value == 'BankCard') {
      return PaymentMethodType.bankCard;
    } else if (value == 'UnlimintApplePay') {
      return PaymentMethodType.applePay;
    } else if (value == 'UnlimintGooglePay') {
      return PaymentMethodType.googlePay;
    } else if (value == 'GlobalSend') {
      return PaymentMethodType.globalSend;
    } else if (value == 'DepositExpressBrasil') {
      return PaymentMethodType.depositExpressBrasil;
    } else if (value == 'Pix') {
      return PaymentMethodType.pix;
    } else if (value == 'Picpay') {
      return PaymentMethodType.picpay;
    } else if (value == 'ConvenienceStore') {
      return PaymentMethodType.convenienceStore;
    } else if (value == 'Codi') {
      return PaymentMethodType.codi;
    } else if (value == 'Spei') {
      return PaymentMethodType.spei;
    } else if (value == 'Oxxo') {
      return PaymentMethodType.oxxo;
    } else if (value == 'Efecty') {
      return PaymentMethodType.efecty;
    } else if (value == 'Baloto') {
      return PaymentMethodType.baloto;
    } else if (value == 'Davivienda') {
      return PaymentMethodType.davivienda;
    } else if (value == 'PagoEfectivo') {
      return PaymentMethodType.pagoEfectivo;
    } else if (value == 'DirectBankingEurope') {
      return PaymentMethodType.directBankingEurope;
    } else if (value == 'Boleto') {
      return PaymentMethodType.boleto;
    } else if (value == 'bpppix') {
      return PaymentMethodType.bpppix;
    } else if (value == 'qrcode3166') {
      return PaymentMethodType.qrcode3166;
    } else if (value == 'daviviendabank') {
      return PaymentMethodType.daviviendabank;
    } else if (value == 'PaymeP2P') {
      return PaymentMethodType.paymeP2P;
    } else {
      return PaymentMethodType.unsupported;
    }
  }

  @override
  dynamic toJson(PaymentMethodType type) => type.name;
}
