import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';

bool isOperationLocal(PaymentMethodType type) {
  const localTypes = [
    PaymentMethodType.baloto,
    PaymentMethodType.bpppix,
    PaymentMethodType.codi,
    PaymentMethodType.convenienceStore,
    PaymentMethodType.qrcode3166,
    PaymentMethodType.pix,
    PaymentMethodType.picpay,
    PaymentMethodType.pagoEfectivo,
    PaymentMethodType.oxxo,
    PaymentMethodType.efecty,
    PaymentMethodType.directBankingEurope,
    PaymentMethodType.depositExpressBrasil,
    PaymentMethodType.daviviendabank,
    PaymentMethodType.davivienda,
  ];

  return localTypes.contains(type);
}

String getLocalOperationName(PaymentMethodType type) {
  switch (type) {
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
