import 'package:simple_networking/config/constants.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

BuyMethodDto setCategoryForBuyMethods(BuyMethodDto dto) {
  PaymentMethodCategory? category;

  switch (dto.id) {
    case PaymentMethodType.bankCard:
      category = PaymentMethodCategory.cards;
      break;
    case PaymentMethodType.paymeP2P:
      category = PaymentMethodCategory.p2p;
      break;
    case PaymentMethodType.baloto:
      category = PaymentMethodCategory.local;
      break;
    case PaymentMethodType.bpppix:
      category = PaymentMethodCategory.local;
      break;
    case PaymentMethodType.codi:
      category = PaymentMethodCategory.local;
      break;
    case PaymentMethodType.convenienceStore:
      category = PaymentMethodCategory.local;
      break;
    case PaymentMethodType.davivienda:
      category = PaymentMethodCategory.local;
      break;
    case PaymentMethodType.daviviendabank:
      category = PaymentMethodCategory.local;
      break;
    case PaymentMethodType.depositExpressBrasil:
      category = PaymentMethodCategory.local;
      break;
    case PaymentMethodType.directBankingEurope:
      category = PaymentMethodCategory.local;
      break;
    case PaymentMethodType.efecty:
      category = PaymentMethodCategory.local;
      break;
    case PaymentMethodType.oxxo:
      category = PaymentMethodCategory.local;
      break;
    case PaymentMethodType.pagoEfectivo:
      category = PaymentMethodCategory.local;
      break;
    case PaymentMethodType.picpay:
      category = PaymentMethodCategory.local;
      break;
    case PaymentMethodType.pix:
      category = PaymentMethodCategory.local;
      break;
    case PaymentMethodType.qrcode3166:
      category = PaymentMethodCategory.local;
      break;
    default:
  }

  return dto.copyWith(
    category: category,
  );
}
