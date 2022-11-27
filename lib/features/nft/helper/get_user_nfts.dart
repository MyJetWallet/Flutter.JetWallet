import 'package:jetwallet/utils/models/nft_model.dart';

List<NftModel> getUserNFTs(List<NftModel> list) {
  final List<NftModel> newList = [];

  for (var i = 0; i < list.length; i++) {
    for (var q = 0; q < list[i].nftList.length; q++) {
      if (list[i].nftList[q].clientId != null) {
        newList.add(list[i]);
      }
    }
  }

  return newList;
}
