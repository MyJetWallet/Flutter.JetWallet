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
    default:
  }

  return dto.copyWith(
    category: category,
  );
}
