import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

NftMarket? findNFTBySymbol(String nftSymbol) {
  for (var i = 0; i < sSignalRModules.nftList.length; i++) {
    for (var q = 0; q < sSignalRModules.nftList[i].nftList.length; q++) {
      if (sSignalRModules.nftList[i].nftList[q].symbol == nftSymbol) {
        return sSignalRModules.nftList[i].nftList[q];
      }
    }
  }

  return null;
}
