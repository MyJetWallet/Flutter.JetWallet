import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

List<NftMarket>? getNFTItemsInCollections(String collectionId) {
  return sSignalRModules.nFTMarkets?.nfts
      .where((element) => element.collectionId == collectionId)
      .toList();
}
