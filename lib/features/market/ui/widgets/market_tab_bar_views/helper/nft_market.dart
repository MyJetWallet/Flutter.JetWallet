import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/models/nft_model.dart';

String nftMarketDescr(int nftCount, List<String> tags) {
  final tagList = tags.join(', ');

  return tagList.isEmpty
      ? '$nftCount ${intl.market_nft_items}'
      : '$nftCount ${intl.market_nft_items} • $tagList';
}

List<NftCollectionCategoryEnum> getNFTFilterList() {
  final filterValues = <NftCollectionCategoryEnum>[];

  for (var i = 0; i < sSignalRModules.nftList.length; i++) {
    if (!filterValues.contains(sSignalRModules.nftList[i].category)) {
      filterValues.add(sSignalRModules.nftList[i].category!);
    }
  }

  return filterValues;
}
