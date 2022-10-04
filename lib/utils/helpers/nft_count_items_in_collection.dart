import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

List<NftMarket>? getNFTItemsInCollections(String collectionId) {
  print(collectionId);

  return sSignalRModules.nftMarketsOS.value?.nfts
      .where((element) => element.collectionId == collectionId)
      .toList();
}
