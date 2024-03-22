import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

BuyMethodDto setCategoryForBuyMethods(BuyMethodDto dto) {
  PaymentMethodCategory? category;

  switch (dto.id) {
    case PaymentMethodType.bankCard:
      category = PaymentMethodCategory.cards;
    case PaymentMethodType.unlimintAlternative:
      category = PaymentMethodCategory.cards;
    case PaymentMethodType.unlimintCard:
      category = PaymentMethodCategory.cards;
    case PaymentMethodType.paymeP2P:
      category = PaymentMethodCategory.p2p;
    case PaymentMethodType.baloto:
      category = PaymentMethodCategory.local;
    case PaymentMethodType.bpppix:
      category = PaymentMethodCategory.local;
    case PaymentMethodType.codi:
      category = PaymentMethodCategory.local;
    case PaymentMethodType.spei:
      category = PaymentMethodCategory.local;
    case PaymentMethodType.convenienceStore:
      category = PaymentMethodCategory.local;
    case PaymentMethodType.davivienda:
      category = PaymentMethodCategory.local;
    case PaymentMethodType.daviviendabank:
      category = PaymentMethodCategory.local;
    case PaymentMethodType.depositExpressBrasil:
      category = PaymentMethodCategory.local;
    case PaymentMethodType.directBankingEurope:
      category = PaymentMethodCategory.local;
    case PaymentMethodType.efecty:
      category = PaymentMethodCategory.local;
    case PaymentMethodType.oxxo:
      category = PaymentMethodCategory.local;
    case PaymentMethodType.pagoEfectivo:
      category = PaymentMethodCategory.local;
    case PaymentMethodType.picpay:
      category = PaymentMethodCategory.local;
    case PaymentMethodType.pix:
      category = PaymentMethodCategory.local;
    case PaymentMethodType.qrcode3166:
      category = PaymentMethodCategory.local;
    default:
  }

  return dto.copyWith(
    category: category,
  );
}
