import 'package:decimal/decimal.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

Decimal calculateNFTPrice(List<NftMarket> list) {
  return list.fold(
    Decimal.zero,
    (Decimal p, e) => p + (e.buyPrice ?? Decimal.zero),
  );
}

Decimal calculateSellNFTPrice(List<NftMarket> list) {
  return list.fold(
    Decimal.zero,
    (Decimal p, e) => p + (e.sellPrice ?? Decimal.zero),
  );
}

List<NftMarket> getNFTOnSell(List<NftMarket> list) {
  return list.where((element) => element.onSell ?? false).toList();
}
